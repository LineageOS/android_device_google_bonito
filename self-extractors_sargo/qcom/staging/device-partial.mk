# Copyright 2018 The Android Open Source Project
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

# AOSP packages required by the blobs
PRODUCT_PACKAGES := \
    com.android.ims.rcsmanager.xml \
    com.android.ims.rcsmanager \
    QtiTelephonyService

#  blob(s) necessary for sargo hardware
PRODUCT_COPY_FILES := \
    vendor/qcom/sargo/proprietary/compatibility_matrix.xml:system/compatibility_matrix.xml:qcom \
    vendor/qcom/sargo/proprietary/andsfCne.xml:system/etc/cne/andsfCne.xml:qcom \
    vendor/qcom/sargo/proprietary/ATT_profiles.xml:system/etc/cne/Nexus/ATT/ATT_profiles.xml:qcom \
    vendor/qcom/sargo/proprietary/ROW_profiles.xml:system/etc/cne/Nexus/ROW/ROW_profiles.xml:qcom \
    vendor/qcom/sargo/proprietary/VZW_profiles.xml:system/etc/cne/Nexus/VZW/VZW_profiles.xml:qcom \
    vendor/qcom/sargo/proprietary/cneapiclient.xml:system/etc/permissions/cneapiclient.xml:qcom \
    vendor/qcom/sargo/proprietary/com.quicinc.cne.xml:system/etc/permissions/com.quicinc.cne.xml:qcom \
    vendor/qcom/sargo/proprietary/embms.xml:system/etc/permissions/embms.xml:qcom \
    vendor/qcom/sargo/proprietary/lpa.xml:system/etc/permissions/lpa.xml:qcom \
    vendor/qcom/sargo/proprietary/LteDirectDiscovery.xml:system/etc/permissions/LteDirectDiscovery.xml:qcom \
    vendor/qcom/sargo/proprietary/qcrilhook.xml:system/etc/permissions/qcrilhook.xml:qcom \
    vendor/qcom/sargo/proprietary/radioconfiginterface.xml:system/etc/permissions/radioconfiginterface.xml:qcom \
    vendor/qcom/sargo/proprietary/radioconfig.xml:system/etc/permissions/radioconfig.xml:qcom \
    vendor/qcom/sargo/proprietary/RemoteSimlock.xml:system/etc/permissions/RemoteSimlock.xml:qcom \
    vendor/qcom/sargo/proprietary/telephonyservice.xml:system/etc/permissions/telephonyservice.xml:qcom \
    vendor/qcom/sargo/proprietary/uimremoteclient.xml:system/etc/permissions/uimremoteclient.xml:qcom \
    vendor/qcom/sargo/proprietary/uimremoteserver.xml:system/etc/permissions/uimremoteserver.xml:qcom \
    vendor/qcom/sargo/proprietary/UimService.xml:system/etc/permissions/UimService.xml:qcom \
    vendor/qcom/sargo/proprietary/com.android.future.usb.accessory.jar:system/framework/com.android.future.usb.accessory.jar:qcom \
    vendor/qcom/sargo/proprietary/com.android.location.provider.jar:system/framework/com.android.location.provider.jar:qcom \
    vendor/qcom/sargo/proprietary/com.android.mediadrm.signer.jar:system/framework/com.android.mediadrm.signer.jar:qcom \
    vendor/qcom/sargo/proprietary/com.qualcomm.qti.uceservice-V2.0-java.jar:system/framework/com.qualcomm.qti.uceservice-V2.0-java.jar:qcom \
    vendor/qcom/sargo/proprietary/javax.obex.jar:system/framework/javax.obex.jar:qcom \
    vendor/qcom/sargo/proprietary/LteDirectDiscoveryLibrary.jar:system/framework/LteDirectDiscoveryLibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/org.apache.http.legacy.boot.jar:system/framework/org.apache.http.legacy.boot.jar:qcom \
    vendor/qcom/sargo/proprietary/org.apache.http.legacy.boot.jar.prof:system/framework/org.apache.http.legacy.boot.jar.prof:qcom \
    vendor/qcom/sargo/proprietary/qcrilhook.jar:system/framework/qcrilhook.jar:qcom \
    vendor/qcom/sargo/proprietary/QtiTelephonyServicelibrary.jar:system/framework/QtiTelephonyServicelibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/radioconfiginterfacelibrary.jar:system/framework/radioconfiginterfacelibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/radioconfiglibrary.jar:system/framework/radioconfiglibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/uimlpalibrary.jar:system/framework/uimlpalibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/uimremoteclientlibrary.jar:system/framework/uimremoteclientlibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/uimremoteserverlibrary.jar:system/framework/uimremoteserverlibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/uimremotesimlocklibrary.jar:system/framework/uimremotesimlocklibrary.jar:qcom \
    vendor/qcom/sargo/proprietary/vendor.qti.hardware.alarm-V1.0-java.jar:system/framework/vendor.qti.hardware.alarm-V1.0-java.jar:qcom \
    vendor/qcom/sargo/proprietary/vendor.qti.hardware.fingerprint-V1.0-java.jar:system/framework/vendor.qti.hardware.fingerprint-V1.0-java.jar:qcom \
    vendor/qcom/sargo/proprietary/vendor.qti.hardware.soter-V1.0-java.jar:system/framework/vendor.qti.hardware.soter-V1.0-java.jar:qcom \
    vendor/qcom/sargo/proprietary/lib64/libadsprpc_system.so:system/lib64/libadsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libcdsprpc_system.so:system/lib64/libcdsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libDiagService.so:system/lib64/libDiagService.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libdiag_system.so:system/lib64/libdiag_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libdisplayconfig.so:system/lib64/libdisplayconfig.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libGPQTEEC_system.so:system/lib64/libGPQTEEC_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libGPTEE_system.so:system/lib64/libGPTEE_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libimscamera_jni.so:system/lib64/libimscamera_jni.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libimsmedia_jni.so:system/lib64/libimsmedia_jni.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/lib-imsvideocodec.so:system/lib64/lib-imsvideocodec.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/lib-imsvtextutils.so:system/lib64/lib-imsvtextutils.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/lib-imsvt.so:system/lib64/lib-imsvt.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/lib-imsvtutils.so:system/lib64/lib-imsvtutils.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/liblistenjni.so:system/lib64/liblistenjni.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/liblistensoundmodel2.so:system/lib64/liblistensoundmodel2.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/liblogcat.so:system/lib64/liblogcat.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libmdsprpc_system.so:system/lib64/libmdsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libminui.so:system/lib64/libminui.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libqsap_sdk.so:system/lib64/libqsap_sdk.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libQTEEConnector_system.so:system/lib64/libQTEEConnector_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/librcc.so:system/lib64/librcc.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libsdm-disp-apis.so:system/lib64/libsdm-disp-apis.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libsdsprpc_system.so:system/lib64/libsdsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libsecureui_svcsock_system.so:system/lib64/libsecureui_svcsock_system.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libsensorslog.so:system/lib64/libsensorslog.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libsepol.so:system/lib64/libsepol.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libsns_low_lat_stream_stub.so:system/lib64/libsns_low_lat_stream_stub.so:qcom \
    vendor/qcom/sargo/proprietary/lib64/libunwind.so:system/lib64/libunwind.so:qcom \
    vendor/qcom/sargo/proprietary/libadsprpc_system.so:system/lib/libadsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/libcdsprpc_system.so:system/lib/libcdsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/libdiag_system.so:system/lib/libdiag_system.so:qcom \
    vendor/qcom/sargo/proprietary/libdisplayconfig.so:system/lib/libdisplayconfig.so:qcom \
    vendor/qcom/sargo/proprietary/libGPQTEEC_system.so:system/lib/libGPQTEEC_system.so:qcom \
    vendor/qcom/sargo/proprietary/libGPTEE_system.so:system/lib/libGPTEE_system.so:qcom \
    vendor/qcom/sargo/proprietary/libimscamera_jni.so:system/lib/libimscamera_jni.so:qcom \
    vendor/qcom/sargo/proprietary/libimsmedia_jni.so:system/lib/libimsmedia_jni.so:qcom \
    vendor/qcom/sargo/proprietary/lib-imsvideocodec.so:system/lib/lib-imsvideocodec.so:qcom \
    vendor/qcom/sargo/proprietary/lib-imsvtextutils.so:system/lib/lib-imsvtextutils.so:qcom \
    vendor/qcom/sargo/proprietary/lib-imsvt.so:system/lib/lib-imsvt.so:qcom \
    vendor/qcom/sargo/proprietary/lib-imsvtutils.so:system/lib/lib-imsvtutils.so:qcom \
    vendor/qcom/sargo/proprietary/liblistenjni.so:system/lib/liblistenjni.so:qcom \
    vendor/qcom/sargo/proprietary/liblistensoundmodel2.so:system/lib/liblistensoundmodel2.so:qcom \
    vendor/qcom/sargo/proprietary/libmdsprpc_system.so:system/lib/libmdsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/libminui.so:system/lib/libminui.so:qcom \
    vendor/qcom/sargo/proprietary/libnl.so:system/lib/libnl.so:qcom \
    vendor/qcom/sargo/proprietary/libpac.so:system/lib/libpac.so:qcom \
    vendor/qcom/sargo/proprietary/libqct_resampler.so:system/lib/libqct_resampler.so:qcom \
    vendor/qcom/sargo/proprietary/libqsap_sdk.so:system/lib/libqsap_sdk.so:qcom \
    vendor/qcom/sargo/proprietary/libQTEEConnector_system.so:system/lib/libQTEEConnector_system.so:qcom \
    vendor/qcom/sargo/proprietary/librcc.so:system/lib/librcc.so:qcom \
    vendor/qcom/sargo/proprietary/libsdm-disp-apis.so:system/lib/libsdm-disp-apis.so:qcom \
    vendor/qcom/sargo/proprietary/libsdsprpc_system.so:system/lib/libsdsprpc_system.so:qcom \
    vendor/qcom/sargo/proprietary/libsecureui_svcsock_system.so:system/lib/libsecureui_svcsock_system.so:qcom \
    vendor/qcom/sargo/proprietary/libsensorslog.so:system/lib/libsensorslog.so:qcom \
    vendor/qcom/sargo/proprietary/libsns_low_lat_stream_stub.so:system/lib/libsns_low_lat_stream_stub.so:qcom \
    vendor/qcom/sargo/proprietary/libunwind.so:system/lib/libunwind.so:qcom \
    vendor/qcom/sargo/proprietary/libsns_low_lat_stream_skel.so:system/lib/rfsa/adsp/libsns_low_lat_stream_skel.so:qcom \
