#!/bin/sh

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
cat | nc hello.yota.ru 80 << EOF
POST /php/go.php HTTP/1.1
Host: hello.yota.ru
Connection: keep-alive
Content-Length: 109
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Origin: http://hello.yota.ru
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36
Content-Type: application/x-www-form-urlencoded
Referer: http://hello.yota.ru/light/
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.8,ru;q=0.6,es;q=0.4

accept_lte=1&redirurl=http%3A%2F%2Fwww.yota.ru%2F&city=msk&connection_type=light&service_id=Sliders_Free_Temp
EOF
