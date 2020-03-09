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

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_KERNEL_ADDITIONAL_FLAGS := \
    DTC=$(shell pwd)/prebuilts/misc/$(HOST_OS)-x86/dtc/dtc \
    MKDTIMG=$(shell pwd)/prebuilts/misc/$(HOST_OS)-x86/libufdt/mkdtimg
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_KERNEL_CONFIG := lineageos_b4s4_defconfig
TARGET_KERNEL_SOURCE := kernel/google/msm-4.9
TARGET_NEEDS_DTBOIMAGE := true

BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true

# Manifests
DEVICE_MANIFEST_FILE += device/google/bonito/lineage_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/google/bonito/lineage_compatibility_matrix.xml

# Partitions
AB_OTA_PARTITIONS += \
    vendor
ifneq ($(PRODUCT_USE_DYNAMIC_PARTITIONS), true)
    BOARD_VENDORIMAGE_PARTITION_SIZE := 805306368
endif
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Reserve space for gapps install
ifneq ($(WITH_GMS),true)
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 12288000
BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := -1
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 1492992000
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 30720000
endif

# SELinux
BOARD_SEPOLICY_DIRS += device/google/bonito/sepolicy-lineage/dynamic
BOARD_SEPOLICY_DIRS += device/google/bonito/sepolicy-lineage/vendor

# Verified Boot
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2
