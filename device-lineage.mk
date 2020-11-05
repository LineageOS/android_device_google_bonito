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

# Build necessary packages for system
PRODUCT_PACKAGES += \
    libmediaplayerservice \
    libstagefright_httplive:64

# Build necessary packages for vendor
PRODUCT_PACKAGES += \
    chre \
    ese_spi_nxp:64 \
    hardware.google.light@1.0.vendor \
    libavservices_minijail_vendor:32 \
    libcodec2_hidl@1.0.vendor:32 \
    libcodec2_vndk.vendor \
    libcppbor.vendor:64 \
    libdisplayconfig \
    libdrm.vendor \
    libhidltransport.vendor \
    libhwbinder.vendor \
    libjson \
    libkeymaster_messages.vendor:64 \
    libkeymaster_portable.vendor:64 \
    libnetfilter_conntrack:64 \
    libnfnetlink:64 \
    libnos:64 \
    libnos_client_citadel:64 \
    libnos_datagram:64 \
    libnos_datagram_citadel:64 \
    libnosprotos:64 \
    libnos_transport:64 \
    libpuresoftkeymasterdevice.vendor:64 \
    libsensorndkbridge:64 \
    libsoft_attestation_cert.vendor:64 \
    libteeui_hal_support.vendor:64 \
    libtinycompress \
    libtinyxml \
    libwifi-hal:64 \
    libwifi-hal-qcom \
    nos_app_avb:64 \
    nos_app_identity:64 \
    nos_app_keymaster:64 \
    nos_app_weaver:64 \
    vendor.display.config@1.0.vendor \
    vendor.display.config@1.1.vendor \
    vendor.display.config@1.2.vendor \
    vendor.display.config@1.3.vendor

# Camera
PRODUCT_PACKAGES += \
    Snap

# Elmyra
PRODUCT_PACKAGES += \
    ElmyraService

# EUICC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml

# Google Assistant
PRODUCT_PRODUCT_PROPERTIES += ro.opa.eligible_device=true

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay@2.0-service-sdm

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-lineage

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true  \
    media.mediadrmservice.enable=true \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno

# Trust HAL
PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service
