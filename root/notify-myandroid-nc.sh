#!/bin/sh

. /root/variables.sh

#if [ -f /tmp/notify.done ] ; then
#   exit 0
#fi

if [ ! -z "$1" ] ; then
P1=$1
else
P1="${EVENT} ${DESC}"
fi

if [ ! -z "$2" ] ; then
P2=$2
else
P1="${EVENT} ${DESC}"
fi

P3="&url=$3"

LEN=$(expr 99 + $(busybox echo -n "${APPLICATION}${P1}${P2}${P3}" | wc -c))

MODEM_UP="0"

while [ "$MODEM_UP" != "1" ] ; do
MODEM_UP=$(ifstatus ${MODEM_INTERFACE} | grep '"up": true' | wc -l)
sleep 10
done

while ! ping -c1 ${PING_HOST} &>/dev/null; do :; done

#killall nc

text="POST /publicapi/notify HTTP/1.0
Host: www.notifymyandroid.com
User-Agent: curl/7.43.0
Accept: */*
Content-Length: ${LEN}
Content-Type: application/x-www-form-urlencoded

apikey=${NMA_KEY}&application=${APPLICATION}&event=${P1}&description=${P2}${P3}&priority=0"

busybox echo -ne "$text" | nc www.notifymyandroid.com 80

#if [ $? -eq 0 ] ; then
#   touch /tmp/notify.done
#fi
