# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/bonito/aosp_bonito.mk)

-include device/google/bonito/bonito/device-lineage.mk

## Device identifier. This must come after all inclusions
PRODUCT_NAME := lineage_bonito
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3a XL
TARGET_MANUFACTURER := Google
PRODUCT_RESTRICT_VENDOR_FILES := false

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=bonito \
    PRIVATE_BUILD_DESC="blueline-user 9 PQ2A.190305.002 5240760 release-keys"

BUILD_FINGERPRINT := google/blueline/blueline:9/PQ2A.190305.002/5240760:user/release-keys

$(call inherit-product-if-exists, vendor/google/bonito/bonito-vendor.mk)
