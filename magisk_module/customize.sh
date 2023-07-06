#! /system/bin/sh
SKIPUNZIP=0

ADBD_APEX="/apex/com.android.adbd"

install() {

    if [ "$ARCH" == "arm64" ] || [ "$ARCH" == "x64" ]; then
        ui_print "- Device Arch: $ARCH"
        mv $MODPATH/common/$ARCH $MODPATH/system
        rm -rf $MODPATH/common
    else
        abort "! Unsupport Arch: $ARCH"
    fi
    
    SYSTEM_ADBD_PATH="$ADBD_APEX/bin/adbd"
    SYSTEM_ADBD_PATH_REAL="$SYSTEM_ADBD_PATH.real"

    MOD_ADBD_PATH="$MODPATH/system/apex/com.android.adbd/bin/adbd"
    MOD_ADBD_PATH_REAL="$MOD_ADBD_PATH.real"

    if [ -e $SYSTEM_ADBD_PATH_REAL ];then
        ui_print "backup $SYSTEM_ADBD_PATH_REAL.."
        cp -f $SYSTEM_ADBD_PATH_REAL $MOD_ADBD_PATH_REAL
    else
        ui_print "backup $SYSTEM_ADBD_PATH.."
        cp -f $SYSTEM_ADBD_PATH $MOD_ADBD_PATH_REAL
    fi

    ui_print "set permissions.."
    chmod 0755 $MOD_ADBD_PATH $MOD_ADBD_PATH_REAL
    chown 0:2000 $MOD_ADBD_PATH $MOD_ADBD_PATH_REAL
    chcon --reference=$SYSTEM_ADBD_PATH $MOD_ADBD_PATH $MOD_ADBD_PATH_REAL
    set_perm $MODPATH/system/lib64/libadb_root_helper.so 0 0 0644 u:object_r:system_lib_file:s0
}

if [ -d "$ADBD_APEX" ]; then
    ui_print "replacing adbd.."

    install
else
    echo "ro.debuggable=1" >> $MODPATH/system.prop
fi
    
ui_print "adb_root installed"
