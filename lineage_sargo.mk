#
# Copyright (C) 2020-2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/bonito/aosp_sargo.mk)

include device/google/bonito/device-lineage.mk

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3a
PRODUCT_NAME := lineage_sargo

# Boot animation
TARGET_SCREEN_HEIGHT := 2220
TARGET_SCREEN_WIDTH := 1080

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_PRODUCT=sargo \
    PRIVATE_BUILD_DESC="sargo-user 12 SQ1A.211205.008 7888514 release-keys"

BUILD_FINGERPRINT := google/sargo/sargo:12/SQ1A.211205.008/7888514:user/release-keys
