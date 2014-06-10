#!/bin/sh
export LC_ALL="en_US.UTF-8"

# environment needed to run nickel
export LD_LIBRARY_PATH=/usr/local/Kobo
export QWS_MOUSE_PROTO="tslib_nocal:/dev/input/event1"
export QWS_KEYBOARD=imx508kbd:/dev/input/event0
export QWS_DISPLAY=Transformed:imx508:Rot90

# we're always starting from our working directory
cd /mnt/onboard/.kobo/koreader/

# export trained OCR data directory
export TESSDATA_PREFIX="data"

# export dict directory
export STARDICT_DATA_DIR="data/dict"

# stop kobo main applications and fmon execution
# fmon is running while nickel is running just for exit from nickel.
# we don't need fmon in koreader but we need to be sure to enable it after koreader execution.
killall nickel
killall hindenburg
killall fmon

# finally call reader
./reader.lua /mnt/onboard 2> crash.log

# back to nickel again
/usr/local/Kobo/pickel disable.rtc.alarm
/sbin/hwclock -s -u

# we need to feed up fmon; disabled right now
# this means fmon will be able to exit from nickel once

echo 1 > /sys/devices/platform/mxc_dvfs_core.0/enable

if [ ! -e /etc/wpa_supplicant/wpa_supplicant.conf ]; then
    cp /etc/wpa_supplicant/wpa_supplicant.conf.template /etc/wpa_supplicant/wpa_supplicant.conf
fi

/usr/local/Kobo/nickel -qws -skipFontLoad


