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

#ifndef DEVICE_GOOGLE_BONITO_PIXELSTATS_SYSFSCOLLECTOR_H
#define DEVICE_GOOGLE_BONITO_PIXELSTATS_SYSFSCOLLECTOR_H

#include <hardware/google/pixelstats/1.0/IPixelStats.h>
#include <utils/StrongPointer.h>

namespace device {
namespace google {
namespace bonito {

class SysfsCollector {
  public:
    void collect();

  private:
    void logAll();

    void logBatteryChargeCycles();

    android::sp<::hardware::google::pixelstats::V1_0::IPixelStats> pixelstats_;
};

}  // namespace bonito
}  // namespace google
}  // namespace device

#endif  // DEVICE_GOOGLE_BONITO_PIXELSTATS_SYSFSCOLLECTOR_H
