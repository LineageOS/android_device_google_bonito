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
TARGET_KERNEL_CONFIG := lineageos_bonito_defconfig
TARGET_KERNEL_SOURCE := kernel/google/msm-4.9

# Manifests
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/google/bonito/lineage_compatibility_matrix.xml
DEVICE_MANIFEST_FILE += device/google/bonito/lineage_manifest.xml

# Partitions
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Reserved Space
ifneq ($(WITH_GMS),true)
    BOARD_PRODUCTIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 15728640
    BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 1476395008
    BOARD_VENDORIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 15728640
endif

# SELinux
BOARD_SEPOLICY_DIRS += device/google/bonito/sepolicy-lineage/dynamic
BOARD_SEPOLICY_DIRS += device/google/bonito/sepolicy-lineage/vendor

# Verified Boot
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2

-include vendor/google/bonito/BoardConfigVendor.mk
