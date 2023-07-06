#! /bin/bash

if [ "$1" = "clean" ];then
    cd adbd_helper && ndk-build clean
    exit
fi

(cd adbd_helper && ndk-build)

cp README.md magisk_module/
cp adbd_helper/libs/arm64-v8a/adbd magisk_module/common/arm64/apex/com.android.adbd/bin/adbd
cp adbd_helper/libs/x86_64/adbd magisk_module/common/x64/apex/com.android.adbd/bin/adbd
cp adbd_helper/libs/arm64-v8a/libadb_root_helper.so magisk_module/common/arm64/lib64/
cp adbd_helper/libs/x86_64/libadb_root_helper.so magisk_module/common/x64/lib64/

(cd magisk_module && find ./ -name "*.keep" -exec rm \{\} \; && zip -r ../adb_root.zip * -x "*.DS_Store")
