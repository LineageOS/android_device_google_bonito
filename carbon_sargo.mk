# Boot animation
TARGET_SCREEN_HEIGHT := 2220
TARGET_SCREEN_WIDTH := 1080

# Inherit Carbon GSM telephony parts
$(call inherit-product, vendor/carbon/config/gsm.mk)

# Inherit Carbon product configuration
$(call inherit-product, vendor/carbon/config/common.mk)

# Inherit device configuration
$(call inherit-product, device/google/bonito/aosp_sargo.mk)

-include device/google/bonito/sargo/device-carbon.mk

## Device identifier. This must come after all inclusions
PRODUCT_NAME := carbon_sargo
PRODUCT_BRAND := google
PRODUCT_MODEL := Pixel 3a
TARGET_MANUFACTURER := Google
PRODUCT_RESTRICT_VENDOR_FILES := false

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=sargo \
    PRIVATE_BUILD_DESC="sargo-user 10 QQ3A.200805.001 6578210 release-keys"

BUILD_FINGERPRINT := google/sargo/sargo:10/QQ3A.200805.001/6578210:user/release-keys

# Include sargo before bonito to use sargo versions of blobs if they exist
$(call inherit-product-if-exists, vendor/google/sargo/sargo-vendor.mk)
$(call inherit-product-if-exists, vendor/google/bonito/bonito-vendor.mk)
