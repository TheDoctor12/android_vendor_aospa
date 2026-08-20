#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Enable support for APEX updates
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# b/344511668
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Enable allowlist for some aosp packages that should not be scanned in a "stopped" state
# Some CTS test case failed after enabling feature config_stopSystemPackagesByDefault
PRODUCT_PACKAGES += initial-package-stopped-states-aosp.xml

# Exclude repos from bp scanning
PRODUCT_SOURCE_ROOT_DIRS += -prebuilts/misc/protobuf_vendorcompat \
    -platform_testing/libraries/sdv \
    -platform_testing/tests/sdv \
    -platform_testing/libraries/automotive/display_safety \
    -platform_testing/tests/automotive/display_safety \
    -device/generic/trusty/microdroid

# Abstruct
PRODUCT_PACKAGES += \
    Abstruct

# AOSPA Version.
$(call inherit-product, vendor/aospa/target/product/version.mk)

# AOSPA private configuration - optional.
$(call inherit-product-if-exists, vendor/aospa-priv/target/product/aospa-priv-target.mk)

ifeq ($(TARGET_DISABLES_GMS), true)
# Vanilla apps
PRODUCT_PACKAGES += \
    AvatarPicker \
    Etar \
    ExactCalculator \
    Glimpse \
    Jelly \
    LatinIME

ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_PACKAGES += \
    Dialer
endif
endif

# APNs
ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/apns-conf.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/apns-conf.xml
endif

# Audio
ifeq ($(TARGET_DISABLES_GMS), true)
# Include AOSP audio files
include vendor/aospa/prebuilts/media/audio/aosp_audio.mk

# Include PA audio files
include vendor/aospa/prebuilts/media/audio/pa_audio.mk

# Default notification/alarm sounds
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=Orion.ogg \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg
endif

# Increase volume level steps
PRODUCT_SYSTEM_PROPERTIES += \
    ro.config.media_vol_steps=30

# Boot Animation
$(call inherit-product, vendor/aospa/bootanimation/bootanimation.mk)

# Camera
PRODUCT_PACKAGES += \
    Aperture

# Charger
ifeq ($(TARGET_DISABLES_GMS), true)
PRODUCT_PACKAGES += \
    charger_res_images_vendor
endif

# curl
PRODUCT_PACKAGES += \
    curl

# Dex2oat
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# Dexpreopt
# Don't dexpreopt prebuilts. (For GMS).
ifneq ($(TARGET_DISABLES_GMS), true)
DONT_DEXPREOPT_PREBUILTS := true
endif

PRODUCT_DEXPREOPT_SPEED_APPS += \
    NexusLauncherRelease \
    SystemUI

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

# Display
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    debug.sf.frame_rate_multiple_threshold=60 \
    ro.surface_flinger.enable_frame_rate_override=false

# EGL - Blobcache configuration
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.egl.blobcache.multifile=true \
    ro.egl.blobcache.multifile_limit=33554432

# Exfat FS
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# Fonts
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/aospa/fonts/,$(TARGET_COPY_OUT_PRODUCT)/fonts) \
    vendor/aospa/target/config/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml

# Gestures
PRODUCT_PACKAGES += \
    vendor.aospa.power-service

# Google - GMS, Pixel, and Mainline Modules
ifneq ($(TARGET_DISABLES_GMS), true)
$(warning Building With GMS)
$(call inherit-product, vendor/google/gms/config.mk)
$(call inherit-product, vendor/google/pixel/config.mk)
ifneq ($(TARGET_EXCLUDE_GMODULES), true)
$(call inherit-product-if-exists, vendor/google/modules/build/mainline_modules.mk)
endif
else
$(warning Building Without GMS)
$(warning Building With microG)
$(call inherit-product-if-exists, vendor/partner_gms/products/gms.mk)
endif

PRODUCT_PRODUCT_PROPERTIES += \
    remote_provisioning.enable_rkpd=true \
    remote_provisioning.hostname=remoteprovisioning.googleapis.com

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
     vendor/aospa/target/config/aospa_vendor_framework_compatibility_matrix.xml

PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    android.hidl.base@1.0.vendor \
    android.hidl.manager@1.0.vendor

# Java Optimizations
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
SYSTEM_OPTIMIZE_JAVA := true
SYSTEMUI_OPTIMIZE_JAVA := true

# MTE
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.system_server=off

# One Handed Mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Overlays
$(call inherit-product, vendor/aospa/overlay/overlays.mk)

# Overlays (Translations)
$(call inherit-product-if-exists, vendor/aospa/translations/translations.mk)

# Paranoid Packages
PRODUCT_PACKAGES += \
    ParanoidPapers \
    ParanoidSystemUI

# Paranoid Sense
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml

# Enable Sense service for 64-bit only
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_SUPPORTS_64_BIT_APPS)

# Lineage-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/sysconfig/lineage-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/lineage-sysconfig.xml

# Twelve
PRODUCT_PACKAGES += \
    Twelve

# Updater
ifeq ($(TARGET_INCLUDE_UPDATER), true)
PRODUCT_PACKAGES += \
    Updater
endif

# LMOFreeform
PRODUCT_PACKAGES += \
    LMOFreeform \
    LMOFreeformSidebar

# Permissions
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/permissions/default_permissions_com.google.android.deskclock.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default_permissions_com.google.android.deskclock.xml \
    vendor/aospa/target/config/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml \
    vendor/aospa/target/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml

# Preinstalled Packages
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/preinstalled-packages-aospa.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-aospa.xml

# Privapp-permissions
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.control_privapp_permissions?=log

# Protobuf - Workaround for prebuilt Qualcomm HAL
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

# QTI VNDK Framework Detect
PRODUCT_PACKAGES += \
    libvndfwk_detect_jni.qti \
    libqti_vndfwk_detect \
    libqti_vndfwk_detect_system \
    libqti_vndfwk_detect_vendor \
    libvndfwk_detect_jni.qti_system \
    libvndfwk_detect_jni.qti_vendor \
    libvndfwk_detect_jni.qti.vendor \
    libqti_vndfwk_detect.vendor

# Qualcomm Common
$(call inherit-product, device/qcom/common/common.mk)

# Rescue Party
# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Sensitive Phone Numbers
ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/sensitive_pn.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sensitive_pn.xml
endif

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor

# StrictMode
ifneq ($(TARGET_BUILD_VARIANT),eng)
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.strictmode.disable=true
endif

# SEPolicy
$(call inherit-product, vendor/aospa/sepolicy/sepolicy.mk)

# Snapdragon Clang
$(call inherit-product, vendor/qcom/sdclang/config/SnapdragonClang.mk)

# Telephony - CLO
PRODUCT_PACKAGES += \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-utils \
    qti_telephony_utils.xml

ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_PACKAGES += \
    tcmiface \
    telephony-ext \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils-prd \
    qti_telephony_utils_prd.xml

# Telephony - AOSP
PRODUCT_PACKAGES += \
    Stk

PRODUCT_BOOT_JARS += \
    tcmiface \
    telephony-ext
endif

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# Theme Picker
PRODUCT_PACKAGES += \
    ThemePicker

# WiFi
PRODUCT_PACKAGES += \
    libwpa_client

PRODUCT_VENDOR_MOVE_ENABLED := true
