#!/bin/sh

# Required by cron
PID=$(pgrep gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

# Properties
FALLBACK_IMG="/usr/share/backgrounds/Flocking_by_noombox.jpg"
IMG_LIST="images.txt"
WEB_ARCHIVE="http://www.bing.com/az/hprichbg/rb"
# End of Properties

# Select an image
SEL_IMG=$(cat $IMG_LIST | shuf -n1)
WEB_LOC="$WEB_ARCHIVE/$SEL_IMG"
TMP_LOC="/tmp/$SEL_IMG"

# Download the image
if [ -f $TMP_LOC ];
then
	rm $TMP_LOC
fi

wget $WEB_LOC -O $TMP_LOC

# Render appropriate image
ERR_CODE=1
if [ -f $TMP_LOC ];
then
	IMG_SIZE=$(du -s $TMP_LOC | awk '{print $1}')
	if [ $IMG_SIZE -gt 100 ];
	then
		ERR_CODE=0
	fi
fi

IMG="$FALLBACK_IMG"
if [ $ERR_CODE -eq 0 ];
then
	IMG="$TMP_LOC"
fi

echo "Background image: $IMG"
echo "Rendered at: `date`" 
gsettings set org.gnome.desktop.background picture-uri file:///$IMG
