#!/bin/sh

. /root/pre-req.sh curl

. /root/variables.sh

#if [ -f /tmp/notify.done ] ; then
#   exit 0
#fi

if [ ! -z "$1" ] ; then
EVENT=$1
fi

if [ ! -z "$2" ] ; then
DESC=$2
fi

if [ ! -z "$3" ] ; then
URL="&url=$3"
fi

MODEM_UP="0"

while [ "$MODEM_UP" != "1" ] ; do
MODEM_UP=$(ifstatus ${MODEM_INTERFACE} | grep '"up": true' | wc -l)
sleep 10
done

while ! ping -c1 ${PING_HOST} &>/dev/null; do :; done

curl -s -i --data-ascii "apikey=${NMA_KEY}" --data-ascii "application=${APPLICATION}" --data-ascii "event=${EVENT}" --data-ascii "description=${DESC}" --data-ascii "priority=0" http://www.notifymyandroid.com/publicapi/notify > /dev/null 2>&1

#if [ $? -eq 0 ] ; then
#   touch /tmp/notify.done
#fi
