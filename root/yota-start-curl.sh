#!/bin/sh

. /root/pre-req.sh curl

. /root/variables.sh

if [ $(ip link show | grep $YOTA_DEVICE | wc -l) != 1 ] ; then
   echo No modem on $YOTA_DEVICE
   exit 0
fi

if [ "$1" == "restart" ] ; then
   ping -c4 ${PING_HOST} &>/dev/null

   if [ $? == 0 ] ; then
      exit 0
   fi
fi

killall nc

while ! ping -c1 hello.yota.ru &>/dev/null; do :; done

curl -s -i -X POST --header "Origin: http://hello.yota.ru" --header "Referer: http://hello.yota.ru/light" --data-ascii "accept_lte=1" --data-ascii "redirurl=http%3A%2F%2Fwww.yota.ru%2F" --data-ascii "city=${YOTA_CITY}" --data-ascii "connection_type=light" --data-ascii "service_id=Sliders_Free_Temp" http://hello.yota.ru/php/go.php
