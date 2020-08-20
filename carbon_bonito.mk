# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Inherit Carbon GSM telephony parts
$(call inherit-product, vendor/carbon/config/gsm.mk)

# Inherit Carbon product configuration
$(call inherit-product, vendor/carbon/config/common.mk)

# Inherit device configuration
$(call inherit-product, device/google/bonito/aosp_bonito.mk)

-include device/google/bonito/bonito/device-carbon.mk

## Device identifier. This must come after all inclusions
PRODUCT_NAME := carbon_bonito
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3a XL
TARGET_MANUFACTURER := Google
PRODUCT_RESTRICT_VENDOR_FILES := false

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=bonito \
    PRIVATE_BUILD_DESC="bonito-user 10 QQ3A.200805.001 6578210 release-keys"

BUILD_FINGERPRINT := google/bonito/bonito:10/QQ3A.200805.001/6578210:user/release-keys

$(call inherit-product-if-exists, vendor/google/bonito/bonito-vendor.mk)
