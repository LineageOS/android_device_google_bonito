# Overlays
DEVICE_PACKAGE_OVERLAYS += device/google/bonito/bonito/overlay-lineage
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += device/google/bonito/bonito/overlay-lineage/lineage-sdk

$(call inherit-product, device/google/bonito/device-lineage.mk)
