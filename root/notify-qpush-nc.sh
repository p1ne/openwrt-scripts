#!/bin/sh

. /root/variables.sh

if [ ! -z "$1" ] ; then
P1=$1
else
P1="${EVENT} ${DESC}"
fi

LEN=$(expr 39 + $(busybox echo -n "${QPUSH_CODE}${QPUSH_NAME}${P1}" | wc -c))

while [ "$MODEM_UP" != "1" ] ; do
MODEM_UP=$(ifstatus ${MODEM_INTERFACE} | grep '"up": true' | wc -l)
sleep 10
done

while ! ping -c1 qpush.me &>/dev/null; do :; done

cat | nc qpush.me 80 << EOF
POST /pusher/push_site/ HTTP/1.1
User-Agent: curl/7.26.0
Host: qpush.me
Accept: */*
Content-Length: ${LEN}
Content-Type: application/x-www-form-urlencoded

name=${QPUSH_NAME}&code=${QPUSH_CODE}&sig=&cache=false&msg[text]=${P1}
EOF


