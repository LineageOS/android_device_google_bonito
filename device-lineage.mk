# Build vendor img
AB_OTA_PARTITIONS += \
    vendor

# Display
PRODUCT_PACKAGES += \
    libdisplayconfig

# DRM
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true \
    media.mediadrmservice.enable=true

DEVICE_PACKAGE_OVERLAYS += device/google/bonito/overlay-lineage

# EUICC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:system/etc/permissions/android.hardware.telephony.euicc.xml

# RCS
PRODUCT_PACKAGES += \
    com.android.ims.rcsmanager \
    PresencePolling \
    RcsService

# Utilities
PRODUCT_PACKAGES += \
    libjson \
    libtinyxml

# WiFi
PRODUCT_PACKAGES += \
    libwifi-hal-qcom

WITH_GMS_FI := true

PRODUCT_COPY_FILES += \
    device/google/bonito/permissions/privapp-permissions-aosp-extended.xml:system/etc/permissions/privapp-permissions-aosp-extended.xml
