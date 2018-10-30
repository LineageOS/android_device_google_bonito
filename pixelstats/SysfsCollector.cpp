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

#include "SysfsCollector.h"

#define LOG_TAG "pixelstats-vendor"

#include <android-base/file.h>
#include <android-base/parseint.h>
#include <android-base/strings.h>
#include <hardware/google/pixelstats/1.0/IPixelStats.h>
#include <utils/Log.h>
#include <utils/StrongPointer.h>
#include <utils/Timers.h>

#include <sys/timerfd.h>
#include <string>

namespace device {
namespace google {
namespace bonito {

using android::base::ReadFileToString;
using ::hardware::google::pixelstats::V1_0::IPixelStats;

const char kCycleCountBinsPath[] = "/sys/class/power_supply/bms/device/cycle_counts_bins";

/**
 * Read the contents of kCycleCountBinsPath and report them via IPixelStats HAL.
 * The contents are expected to be N buckets total, the nth of which indicates the
 * number of times battery %-full has been increased with the n/N% full bucket.
 */
void SysfsCollector::logBatteryChargeCycles() {
    std::string file_contents;
    if (!ReadFileToString(kCycleCountBinsPath, &file_contents)) {
        ALOGE("Unable to read battery charge cycles - %s", strerror(errno));
        return;
    }

    std::replace(file_contents.begin(), file_contents.end(), ' ', ',');
    ALOGI("logBatteryChargeCycles - %s", file_contents.data());
    pixelstats_->reportChargeCycles(android::base::Trim(file_contents));
}

void SysfsCollector::logAll() {
    pixelstats_ = IPixelStats::tryGetService();
    if (!pixelstats_) {
        ALOGE("Unable to connect to PixelStats service");
        return;
    }

    logBatteryChargeCycles();
 
    pixelstats_.clear();
}

/**
 * Loop forever collecting stats from sysfs nodes and reporting them via
 * IPixelStats.
 */
void SysfsCollector::collect(void) {
    int timerfd = timerfd_create(CLOCK_BOOTTIME, 0);
    if (timerfd < 0) {
        ALOGE("Unable to create timerfd - %s", strerror(errno));
        return;
    }

    // Sleep for 30 seconds on launch to allow codec driver to load.
    sleep(30);

    // Collect first set of stats on boot.
    logAll();

    // Collect stats every 24hrs after.
    struct itimerspec period;
    const int kSecondsPerDay = 60 * 60 * 24;
    period.it_interval.tv_sec = kSecondsPerDay;
    period.it_interval.tv_nsec = 0;
    period.it_value.tv_sec = kSecondsPerDay;
    period.it_value.tv_nsec = 0;

    if (timerfd_settime(timerfd, 0, &period, NULL)) {
        ALOGE("Unable to set 24hr timer - %s", strerror(errno));
        return;
    }

    while (1) {
        int readval;
        do {
            char buf[8];
            errno = 0;
            readval = read(timerfd, buf, sizeof(buf));
        } while (readval < 0 && errno == EINTR);
        if (readval < 0) {
            ALOGE("Timerfd error - %s\n", strerror(errno));
            return;
        }
        logAll();
    }
}

}  // namespace bonito
}  // namespace google
}  // namespace device
