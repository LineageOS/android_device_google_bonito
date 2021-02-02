# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/bonito/aosp_bonito.mk)

-include device/google/bonito/device-lineage.mk

## Device identifier. This must come after all inclusions
PRODUCT_NAME := lineage_bonito
PRODUCT_MODEL := Pixel 3a XL
PRODUCT_BRAND := google

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=bonito \
    PRIVATE_BUILD_DESC="bonito-user 11 RQ1A.210205.004 7038034 release-keys"

BUILD_FINGERPRINT := google/bonito/bonito:11/RQ1A.210205.004/7038034:user/release-keys

$(call inherit-product-if-exists, vendor/google/bonito/bonito-vendor.mk)
