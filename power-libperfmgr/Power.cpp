/*
 * Copyright (C) 2018 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define ATRACE_TAG (ATRACE_TAG_POWER | ATRACE_TAG_HAL)
#define LOG_TAG "android.hardware.power@1.3-service.bonito-libperfmgr"

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android-base/strings.h>
#include <android-base/stringprintf.h>

#include <mutex>

#include <utils/Log.h>
#include <utils/Trace.h>

#include "Power.h"
#include "power-helper.h"
#include "display-helper.h"

/* RPM runs at 19.2Mhz. Divide by 19200 for msec */
#define RPM_CLK 19200

extern struct stats_section master_sections[];

namespace android {
namespace hardware {
namespace power {
namespace V1_3 {
namespace implementation {

using ::android::hardware::power::V1_0::Feature;
using ::android::hardware::power::V1_0::PowerStatePlatformSleepState;
using ::android::hardware::power::V1_0::Status;
using ::android::hardware::power::V1_1::PowerStateSubsystem;
using ::android::hardware::power::V1_1::PowerStateSubsystemSleepState;
using ::android::hardware::hidl_vec;
using ::android::hardware::Return;
using ::android::hardware::Void;

static const std::map<enum CameraStreamingMode, std::string> kCamStreamingHint = {
    {CAMERA_STREAMING_OFF, "CAMERA_STREAMING_OFF"},
    {CAMERA_STREAMING, "CAMERA_STREAMING"},
    {CAMERA_STREAMING_1080P, "CAMERA_STREAMING_1080P"},
    {CAMERA_STREAMING_4K, "CAMERA_STREAMING_4K"}};

Power::Power()
    : mHintManager(nullptr),
      mInteractionHandler(nullptr),
      mSustainedPerfModeOn(false),
      mCameraStreamingMode(CAMERA_STREAMING_OFF),
      mReady(false) {
    mInitThread =
            std::thread([this](){
                            android::base::WaitForProperty(kPowerHalInitProp, "1");
                            mHintManager = HintManager::GetFromJSON("/vendor/etc/powerhint.json");
                            mInteractionHandler = std::make_unique<InteractionHandler>(mHintManager);
                            mInteractionHandler->Init();
                            std::string state = android::base::GetProperty(kPowerHalStateProp, "");
                            if (state == "CAMERA_STREAMING") {
                                ALOGI("Initialize with CAMERA_STREAMING on");
                                mHintManager->DoHint("CAMERA_STREAMING");
                                mCameraStreamingMode = CAMERA_STREAMING;
                            } else if (state == "CAMERA_STREAMING_1080P") {
                                ALOGI("Initialize CAMERA_STREAMING_1080P on");
                                mHintManager->DoHint("CAMERA_STREAMING_1080P");
                                mCameraStreamingMode = CAMERA_STREAMING_1080P;
                            } else if (state == "CAMERA_STREAMING_4K") {
                                ALOGI("Initialize with CAMERA_STREAMING_4K on");
                                mHintManager->DoHint("CAMERA_STREAMING_4K");
                                mCameraStreamingMode = CAMERA_STREAMING_4K;
                            } else if (state == "SUSTAINED_PERFORMANCE") {
                                ALOGI("Initialize with SUSTAINED_PERFORMANCE on");
                                mHintManager->DoHint("SUSTAINED_PERFORMANCE");
                                mSustainedPerfModeOn = true;
                            } else {
                                ALOGI("Initialize PowerHAL");
                            }

                            state = android::base::GetProperty(kPowerHalAudioProp, "");
                            if (state == "LOW_LATENCY") {
                                ALOGI("Initialize with AUDIO_LOW_LATENCY on");
                                mHintManager->DoHint("AUDIO_LOW_LATENCY");
                            }

                            state = android::base::GetProperty(kPowerHalRenderingProp, "");
                            if (state == "EXPENSIVE_RENDERING") {
                                ALOGI("Initialize with EXPENSIVE_RENDERING on");
                                mHintManager->DoHint("EXPENSIVE_RENDERING");
                            }
                            // Now start to take powerhint
                            mReady.store(true);
                        });
    mInitThread.detach();
}

// Methods from ::android::hardware::power::V1_0::IPower follow.
Return<void> Power::setInteractive(bool /* interactive */)  {
    return Void();
}

Return<void> Power::powerHint(PowerHint_1_0 hint, int32_t data) {
    if (!isSupportedGovernor() || !mReady) {
        return Void();
    }

    switch(hint) {
        case PowerHint_1_0::INTERACTION:
            if (mSustainedPerfModeOn) {
                ALOGV("%s: ignoring due to other active perf hints", __func__);
            } else {
                mInteractionHandler->Acquire(data);
            }
            break;
        case PowerHint_1_0::SUSTAINED_PERFORMANCE:
            if (data && !mSustainedPerfModeOn) {
                ALOGD("SUSTAINED_PERFORMANCE ON");
                mHintManager->DoHint("SUSTAINED_PERFORMANCE");
                if (!android::base::SetProperty(kPowerHalStateProp, "SUSTAINED_PERFORMANCE")) {
                    ALOGE("%s: could not set powerHAL state property to SUSTAINED_PERFORMANCE", __func__);
                }
                mSustainedPerfModeOn = true;
            } else if (!data && mSustainedPerfModeOn) {
                ALOGD("SUSTAINED_PERFORMANCE OFF");
                mHintManager->EndHint("SUSTAINED_PERFORMANCE");
                if (!android::base::SetProperty(kPowerHalStateProp, "")) {
                    ALOGE("%s: could not clear powerHAL state property", __func__);
                }
                mSustainedPerfModeOn = false;
            }
            break;
        case PowerHint_1_0::LAUNCH:
            ATRACE_BEGIN("launch");
            if (mSustainedPerfModeOn) {
                ALOGV("%s: ignoring due to other active perf hints", __func__);
            } else {
                if (data) {
                    // Hint until canceled
                    ATRACE_INT("launch_lock", 1);
                    mHintManager->DoHint("LAUNCH");
                    ALOGD("LAUNCH ON");
                } else {
                    ATRACE_INT("launch_lock", 0);
                    mHintManager->EndHint("LAUNCH");
                    ALOGD("LAUNCH OFF");
                }
            }
            ATRACE_END();
            break;
        case PowerHint_1_0::LOW_POWER:
            {
            ATRACE_BEGIN("low-power");

            if (data) {
              // Device in battery saver mode, enable display low power mode
              set_display_lpm(true);
            } else {
              // Device exiting battery saver mode, disable display low power mode
              set_display_lpm(false);
            }
            ATRACE_END();
            }
            break;
        default:
            break;

    }
    return Void();
}

Return<void> Power::setFeature(Feature /*feature*/, bool /*activate*/)  {
    //Nothing to do
    return Void();
}

Return<void> Power::getPlatformLowPowerStats(getPlatformLowPowerStats_cb _hidl_cb) {

    hidl_vec<PowerStatePlatformSleepState> states;
    uint64_t stats[SYSTEM_SLEEP_STATE_COUNT * SYSTEM_STATE_STATS_COUNT] = {0};
    uint64_t *state_stats;
    struct PowerStatePlatformSleepState *state;

    states.resize(SYSTEM_SLEEP_STATE_COUNT);

    if (extract_system_stats(stats, ARRAY_SIZE(stats)) != 0) {
        states.resize(0);
        goto done;
    }

    /* Update statistics for AOSD */
    state = &states[SYSTEM_STATE_AOSD];
    state->name = "AOSD";
    state_stats = &stats[SYSTEM_STATE_AOSD * SYSTEM_STATE_STATS_COUNT];

    state->residencyInMsecSinceBoot = state_stats[ACCUMULATED_TIME_MS];
    state->totalTransitions = state_stats[TOTAL_COUNT];
    state->supportedOnlyInSuspend = false;
    state->voters.resize(0);

    /* Update statistics for CXSD */
    state = &states[SYSTEM_STATE_CXSD];
    state->name = "CXSD";
    state_stats = &stats[SYSTEM_STATE_CXSD * SYSTEM_STATE_STATS_COUNT];

    state->residencyInMsecSinceBoot = state_stats[ACCUMULATED_TIME_MS];
    state->totalTransitions = state_stats[TOTAL_COUNT];
    state->supportedOnlyInSuspend = false;
    state->voters.resize(0);

done:
    _hidl_cb(states, Status::SUCCESS);
    return Void();
}

static int get_master_low_power_stats(hidl_vec<PowerStateSubsystem> *subsystems) {
    uint64_t all_stats[MASTER_COUNT * MASTER_STATS_COUNT] = {0};
    uint64_t *section_stats;
    struct PowerStateSubsystem *subsystem;
    struct PowerStateSubsystemSleepState *state;

    if (extract_master_stats(all_stats, ARRAY_SIZE(all_stats)) != 0) {
        for (size_t i = 0; i < MASTER_COUNT; i++) {
            (*subsystems)[i].name = master_sections[i].label;
            (*subsystems)[i].states.resize(0);
        }
        return -1;
    }

    for (size_t i = 0; i < MASTER_COUNT; i++) {
        subsystem = &(*subsystems)[i];
        subsystem->name = master_sections[i].label;
        subsystem->states.resize(MASTER_SLEEP_STATE_COUNT);

        state = &(subsystem->states[MASTER_SLEEP]);
        section_stats = &all_stats[i * MASTER_STATS_COUNT];

        state->name = "Sleep";
        state->totalTransitions = section_stats[SLEEP_ENTER_COUNT];
        state->residencyInMsecSinceBoot = section_stats[SLEEP_CUMULATIVE_DURATION_MS] / RPM_CLK;
        state->lastEntryTimestampMs = section_stats[SLEEP_LAST_ENTER_TSTAMP_MS] / RPM_CLK;
        state->supportedOnlyInSuspend = false;
    }

    return 0;
}

static int get_wlan_low_power_stats(struct PowerStateSubsystem *subsystem) {
    uint64_t stats[WLAN_STATS_COUNT] = {0};
    struct PowerStateSubsystemSleepState *state;

    subsystem->name = "wlan";

    if (extract_wlan_stats(stats, ARRAY_SIZE(stats)) != 0) {
        subsystem->states.resize(0);
        return -1;
    }

    subsystem->states.resize(WLAN_SLEEP_STATE_COUNT);

    /* Update statistics for Active State */
    state = &subsystem->states[WLAN_STATE_ACTIVE];
    state->name = "Active";
    state->residencyInMsecSinceBoot = stats[CUMULATIVE_TOTAL_ON_TIME_MS];
    state->totalTransitions = stats[DEEP_SLEEP_ENTER_COUNTER];
    state->lastEntryTimestampMs = 0; //FIXME need a new value from Qcom
    state->supportedOnlyInSuspend = false;

    /* Update statistics for Deep-Sleep state */
    state = &subsystem->states[WLAN_STATE_DEEP_SLEEP];
    state->name = "Deep-Sleep";
    state->residencyInMsecSinceBoot = stats[CUMULATIVE_SLEEP_TIME_MS];
    state->totalTransitions = stats[DEEP_SLEEP_ENTER_COUNTER];
    state->lastEntryTimestampMs = stats[LAST_DEEP_SLEEP_ENTER_TSTAMP_MS];
    state->supportedOnlyInSuspend = false;

    return 0;
}

// Methods from ::android::hardware::power::V1_1::IPower follow.
Return<void> Power::getSubsystemLowPowerStats(getSubsystemLowPowerStats_cb _hidl_cb) {
    hidl_vec<PowerStateSubsystem> subsystems;

    subsystems.resize(STATS_SOURCE_COUNT);

    // Get low power stats for all of the system masters.
    if (get_master_low_power_stats(&subsystems) != 0) {
        ALOGE("%s: failed to process master stats", __func__);
    }

    // Get WLAN subsystem low power stats.
    if (get_wlan_low_power_stats(&subsystems[SUBSYSTEM_WLAN]) != 0) {
        ALOGE("%s: failed to process wlan stats", __func__);
    }

    _hidl_cb(subsystems, Status::SUCCESS);
    return Void();
}

bool Power::isSupportedGovernor() {
    std::string buf;
    if (android::base::ReadFileToString("/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor", &buf)) {
        buf = android::base::Trim(buf);
    }
    // Only support EAS 1.2, legacy EAS
    if (buf == "schedutil" || buf == "sched") {
        return true;
    } else {
        LOG(ERROR) << "Governor not supported by powerHAL, skipping";
        return false;
    }
}

Return<void> Power::powerHintAsync(PowerHint_1_0 hint, int32_t data) {
    // just call the normal power hint in this oneway function
    return powerHint(hint, data);
}

// Methods from ::android::hardware::power::V1_2::IPower follow.
Return<void> Power::powerHintAsync_1_2(PowerHint_1_2 hint, int32_t data) {
    if (!isSupportedGovernor() || !mReady) {
        return Void();
    }

    switch(hint) {
        case PowerHint_1_2::AUDIO_LOW_LATENCY:
            ATRACE_BEGIN("audio_low_latency");
            if (data) {
                // Hint until canceled
                ATRACE_INT("audio_low_latency_lock", 1);
                mHintManager->DoHint("AUDIO_LOW_LATENCY");
                ALOGD("AUDIO LOW LATENCY ON");
                if (!android::base::SetProperty(kPowerHalAudioProp, "LOW_LATENCY")) {
                    ALOGE("%s: could not set powerHAL audio state property to LOW_LATENCY", __func__);
                }
            } else {
                ATRACE_INT("audio_low_latency_lock", 0);
                mHintManager->EndHint("AUDIO_LOW_LATENCY");
                ALOGD("AUDIO LOW LATENCY OFF");
                if (!android::base::SetProperty(kPowerHalAudioProp, "")) {
                    ALOGE("%s: could not clear powerHAL audio state property", __func__);
                }
            }
            ATRACE_END();
            break;
        case PowerHint_1_2::AUDIO_STREAMING:
            ATRACE_BEGIN("audio_streaming");
            if (mSustainedPerfModeOn) {
                ALOGV("%s: ignoring due to other active perf hints", __func__);
            } else {
                if (data) {
                    // Hint until canceled
                    ATRACE_INT("audio_streaming_lock", 1);
                    mHintManager->DoHint("AUDIO_STREAMING");
                    ALOGD("AUDIO STREAMING ON");
                } else {
                    ATRACE_INT("audio_streaming_lock", 0);
                    mHintManager->EndHint("AUDIO_STREAMING");
                    ALOGD("AUDIO STREAMING OFF");
                }
            }
            ATRACE_END();
            break;
        case PowerHint_1_2::CAMERA_LAUNCH:
            ATRACE_BEGIN("camera_launch");
            if (data > 0) {
                ATRACE_INT("camera_launch_lock", 1);
                mHintManager->DoHint("CAMERA_LAUNCH", std::chrono::milliseconds(data));
                ALOGD("CAMERA LAUNCH ON: %d MS, LAUNCH ON: 2500 MS", data);
                // boosts 2.5s for launching
                mHintManager->DoHint("LAUNCH", std::chrono::milliseconds(2500));
            } else if (data == 0) {
                ATRACE_INT("camera_launch_lock", 0);
                mHintManager->EndHint("CAMERA_LAUNCH");
                ALOGD("CAMERA LAUNCH OFF");
            } else {
                ALOGE("CAMERA LAUNCH INVALID DATA: %d", data);
            }
            ATRACE_END();
            break;
        case PowerHint_1_2::CAMERA_STREAMING: {
            const enum CameraStreamingMode mode = static_cast<enum CameraStreamingMode>(data);
            if (mode < CAMERA_STREAMING_OFF || mode >= CAMERA_STREAMING_MAX) {
                ALOGE("CAMERA STREAMING INVALID Mode: %d", mode);
                break;
            }

            if (mCameraStreamingMode == mode)
                break;

            ATRACE_BEGIN("camera_streaming");
            // turn it off first if any previous hint.
            if ((mCameraStreamingMode != CAMERA_STREAMING_OFF)) {
                const auto modeValue = kCamStreamingHint.at(mCameraStreamingMode);
                ATRACE_INT("camera_streaming_lock", 0);
                mHintManager->EndHint(modeValue);
                // Boost 1s for tear down
                mHintManager->DoHint("CAMERA_LAUNCH", std::chrono::seconds(1));
                ALOGD("CAMERA %s OFF", modeValue.c_str());
            }

            if (mode != CAMERA_STREAMING_OFF) {
                const auto hintValue = kCamStreamingHint.at(mode);
                ATRACE_INT("camera_streaming_lock", mode);
                mHintManager->DoHint(hintValue);
                ALOGD("CAMERA %s ON", hintValue.c_str());
            }

            mCameraStreamingMode = mode;
            const auto prop = (mCameraStreamingMode == CAMERA_STREAMING_OFF)
                                  ? ""
                                  : kCamStreamingHint.at(mode).c_str();
            if (!android::base::SetProperty(kPowerHalStateProp, prop)) {
                ALOGE("%s: could set powerHAL state %s property", __func__, prop);
            }
            ATRACE_END();
            break;
        }
        case PowerHint_1_2::CAMERA_SHOT:
            ATRACE_BEGIN("camera_shot");
            if (data > 0) {
                ATRACE_INT("camera_shot_lock", 1);
                mHintManager->DoHint("CAMERA_SHOT", std::chrono::milliseconds(data));
                ALOGD("CAMERA SHOT ON: %d MS", data);
            } else if (data == 0) {
                ATRACE_INT("camera_shot_lock", 0);
                mHintManager->EndHint("CAMERA_SHOT");
                ALOGD("CAMERA SHOT OFF");
            } else {
                ALOGE("CAMERA SHOT INVALID DATA: %d", data);
            }
            ATRACE_END();
            break;
        default:
            return powerHint(static_cast<PowerHint_1_0>(hint), data);
    }
    return Void();
}

// Methods from ::android::hardware::power::V1_3::IPower follow.
Return<void> Power::powerHintAsync_1_3(PowerHint_1_3 hint, int32_t data) {
    if (!isSupportedGovernor() || !mReady) {
        return Void();
    }

    if (hint == PowerHint_1_3::EXPENSIVE_RENDERING) {
        if (mSustainedPerfModeOn) {
            ALOGV("%s: ignoring due to other active perf hints", __func__);
            return Void();
        }

        if (data > 0) {
            ATRACE_INT("EXPENSIVE_RENDERING", 1);
            mHintManager->DoHint("EXPENSIVE_RENDERING");
            if (!android::base::SetProperty(kPowerHalRenderingProp, "EXPENSIVE_RENDERING")) {
                ALOGE("%s: could not set powerHAL rendering property to EXPENSIVE_RENDERING",
                      __func__);
            }
        } else {
            ATRACE_INT("EXPENSIVE_RENDERING", 0);
            mHintManager->EndHint("EXPENSIVE_RENDERING");
            if (!android::base::SetProperty(kPowerHalRenderingProp, "")) {
                ALOGE("%s: could not clear powerHAL rendering property", __func__);
            }
        }
    } else {
        return powerHintAsync_1_2(static_cast<PowerHint_1_2>(hint), data);
    }

    return Void();
}

constexpr const char* boolToString(bool b) {
    return b ? "true" : "false";
}

Return<void> Power::debug(const hidl_handle& handle, const hidl_vec<hidl_string>&) {
    if (handle != nullptr && handle->numFds >= 1 && mReady) {
        int fd = handle->data[0];

        std::string buf(
            android::base::StringPrintf("HintManager Running: %s\n"
                                        "CameraStreamingMode: %s\n"
                                        "SustainedPerformanceMode: %s\n",
                                        boolToString(mHintManager->IsRunning()),
                                        kCamStreamingHint.at(mCameraStreamingMode).c_str(),
                                        boolToString(mSustainedPerfModeOn)));
        // Dump nodes through libperfmgr
        mHintManager->DumpToFd(fd);
        if (!android::base::WriteStringToFd(buf, fd)) {
            PLOG(ERROR) << "Failed to dump state to fd";
        }
        fsync(fd);
    }
    return Void();
}

}  // namespace implementation
}  // namespace V1_3
}  // namespace power
}  // namespace hardware
}  // namespace android
