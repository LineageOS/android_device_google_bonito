#
# Copyright (C) 2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Camera
PRODUCT_PACKAGES += Snap

# Display
PRODUCT_PACKAGES += \
    libdisplayconfig

# EUICC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml

# GMS
WITH_GMS_FI := true

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay@2.0-service-sdm

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-lineage
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += $(LOCAL_PATH)/overlay-lineage/lineage-sdk
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += $(LOCAL_PATH)/overlay/packages/apps/Bluetooth

# Partitions
AB_OTA_PARTITIONS += \
    vendor

# Privapp Permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/privapp-permissions-aosp-extended.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-aosp-extended.xml

# Properties
TARGET_VENDOR_PROP := $(LOCAL_PATH)/vendor.prop

# RCS
PRODUCT_PACKAGES += \
    com.android.ims.rcsmanager \
    PresencePolling \
    RcsService

# Trust HAL
PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service

# Utilities
PRODUCT_PACKAGES += \
    libjson \
    libtinyxml

# Wi-Fi
PRODUCT_PACKAGES += \
    libwifi-hal-qcom
