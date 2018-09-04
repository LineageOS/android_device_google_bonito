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
#define LOG_TAG "android.hardware.health@2.0-service.bonito"
#include <android-base/logging.h>

#include <android-base/file.h>
#include <android-base/parseint.h>
#include <android-base/strings.h>
#include <health2/Health.h>
#include <health2/service.h>
#include <healthd/healthd.h>
#include <hidl/HidlTransportSupport.h>

#include <fstream>
#include <iomanip>
#include <string>
#include <vector>

#include "BatteryRechargingControl.h"

namespace {

using android::hardware::health::V2_0::DiskStats;
using android::hardware::health::V2_0::StorageAttribute;
using android::hardware::health::V2_0::StorageInfo;
using ::device::google::bonito::health::BatteryRechargingControl;

static BatteryRechargingControl battRechargingControl;

#define EMMC_DIR "/sys/devices/platform/soc/7c4000.sdhci/mmc_host/mmc0/mmc0:0001"
const std::string kEmmcHealthEol{EMMC_DIR "/pre_eol_info"};
const std::string kEmmcHealthLifetime{EMMC_DIR "/life_time"};
const std::string kEmmcVersion{EMMC_DIR "/fwrev"};
const std::string kDiskStatsFile{"/sys/block/mmcblk0/stat"};
const std::string kEmmcName{"MMC0"};

std::ifstream assert_open(const std::string& path) {
    std::ifstream stream(path);
    if (!stream.is_open()) {
        LOG(FATAL) << "Cannot read " << path;
    }
    return stream;
}

template <typename T>
void read_value_from_file(const std::string& path, T* field) {
    auto stream = assert_open(path);
    stream.unsetf(std::ios_base::basefield);
    stream >> *field;
}

void read_emmc_version(StorageInfo* info) {
    uint64_t value;
    read_value_from_file(kEmmcVersion, &value);
    std::stringstream ss;
    ss << "mmc0 " << std::hex << value;
    info->version = ss.str();
}

void fill_emmc_storage_attribute(StorageAttribute* attr) {
    attr->isInternal = true;
    attr->isBootDevice = true;
    attr->name = kEmmcName;
}

}  // anonymous namespace

void healthd_board_init(struct healthd_config*) {
}

int healthd_board_battery_update(struct android::BatteryProperties *props) {
    battRechargingControl.updateBatteryProperties(props);
    return 0;
}

void get_storage_info(std::vector<StorageInfo>& vec_storage_info) {
    vec_storage_info.resize(1);
    StorageInfo* storage_info = &vec_storage_info[0];
    fill_emmc_storage_attribute(&storage_info->attr);

    read_emmc_version(storage_info);
    read_value_from_file(kEmmcHealthEol, &storage_info->eol);
    read_value_from_file(kEmmcHealthLifetime, &storage_info->lifetimeA);
    read_value_from_file(kEmmcHealthLifetime, &storage_info->lifetimeB);
    return;
}

void get_disk_stats(std::vector<DiskStats>& vec_stats) {
    vec_stats.resize(1);
    DiskStats* stats = &vec_stats[0];
    fill_emmc_storage_attribute(&stats->attr);

    auto stream = assert_open(kDiskStatsFile);
    // Regular diskstats entries
    stream >> stats->reads
           >> stats->readMerges
           >> stats->readSectors
           >> stats->readTicks
           >> stats->writes
           >> stats->writeMerges
           >> stats->writeSectors
           >> stats->writeTicks
           >> stats->ioInFlight
           >> stats->ioTicks
           >> stats->ioInQueue;
    return;
}

int main(void) {
    return health_service_main();
}
