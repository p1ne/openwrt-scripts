#!/bin/sh

. /root/pre-req.sh wget

. /root/variables.sh

MODEM_UP="0"

while [ "$MODEM_UP" != "1" ] ; do
MODEM_UP=$(ifstatus ${MODEM_INTERFACE} | grep '"up": true' | wc -l)
sleep 10
done

PARAM=$(4gmodem | grep -e MCC -e LAC -e LCID | cut -f 3,4,7,10 -d\ | tr -d \(\))
MCC=$(echo $PARAM | cut -f 1 -d\ )
MNC=$(echo $PARAM | cut -f 2 -d\ )
LAC=$(echo $PARAM | cut -f 3 -d\ )
LCID=$(echo $PARAM | cut -f 4 -d\ )

URL="http://opencellid.org/cell/get?key=${OPENCELLID_KEY}&mcc=${MCC}&mnc=${MNC}&lac=${LAC}&cellid=${LCID}&format=json"

COORD=$(wget $URL -q -O - | grep -e lon -e lat | cut -f4 -d\ | tr -d ,)

LAT=$(echo $COORD | cut -f 1 -d\ )
LON=$(echo $COORD | cut -f 2 -d\ )

YANDEX_URL="http%3A%2F%2Fstatic-maps.yandex.ru%2F1.x%2F%3Fl%3Dmap%26pt%3D${LAT}%2C${LON},pm2ntl%26z%3D16"

if [ -x $NOTIFY_SCRIPT ] ; then
    $NOTIFY_SCRIPT "${MODEM_INTERFACE}" "Coordinates" "$YANDEX_URL"
fi

