#!/bin/bash

. /root/pre-req.sh curl

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

HEADER="Content-Type: application/json"

REQUEST_BODY="json={
   \"common\": {
      \"version\": \"1.0\",
      \"api_key\": \"${YANDEX_KEY}\"
   },
   \"gsm_cells\": [
       {
          \"countrycode\": $MCC,
          \"operatorid\": $MNC,
          \"cellid\": $LCID,
          \"lac\": $LAC,
          \"age\": 5555
       }
   ]
}"

COORD=$(curl -s -i -X POST -H "$HEADER" -d "$REQUEST_BODY" http://api.lbs.yandex.net/geolocation)

LAT=$(echo "$COORD" | tr \  \\n | grep -e latitude -e longitude -A 3 | tr \\n \ | cut -f 8 -d\ | tr -d ,)
LON=$(echo "$COORD" | tr \  \\n | grep -e latitude -e longitude -A 3 | tr \\n \ | cut -f 3 -d\ | tr -d ,)

YANDEX_URL="http%3A%2F%2Fstatic-maps.yandex.ru%2F1.x%2F%3Fl%3Dmap%26pt%3D${LAT}%2C${LON}%2Cpm2ntl%26z%3D16"

if [ -x $NOTIFY_SCRIPT ] ; then
    $NOTIFY_SCRIPT "${MODEM_INTERFACE}" "Coordinates" "$YANDEX_URL"
fi

