#!/bin/sh

. /root/variables.sh

PHONE_ON=$(iw wlan0 scan | grep -e "SSID: $PHONE_AP_NAME" -e "$PHONE_AP_MAC" | wc -l)

if [ "$PHONE_ON" == "2" ] ; then
	PHONE_CONNECTED=$(iw wlan0 link | grep "SSID: $PHONE_AP_NAME" | wc -l)
	if [ "$PHONE_CONNECTED" == "1" ] ; then
		exit 0
	fi

	ROUTER_CONFIG=$(grep $ROUTER_AP_NAME /etc/config/wireless | wc -l)
	if [ "$ROUTER_CONFIG" == "1" ] ; then
                while read line; do eval echo \"$line\"; done < /root/wireless.${PHONE_AP_NAME} > /etc/config/wireless
		uci commit wireless
		wifi
		ifdown \'${MODEM_IFACE}\'
	fi
else
	PHONE_CONFIG=$(grep $PHONE_AP_NAME /etc/config/wireless | wc -l)
	if [ "$PHONE_CONFIG" == "1" ] ; then
                while read line; do eval echo \"$line\"; done < /root/wireless.${ROUTER_AP_NAME} > /etc/config/wireless
		uci commit wireless
		wifi
	fi
	MODEM_DOWN=$(ifstatus \'${MODEM_IFACE}\' | grep '"up": false' | wc -l)
	if [ "$MODEM_DOWN" == "1" ] ; then
		ifdown \'${MODEM_IFACE}\'
		if [ ! -f ${MODEM_DEVICE} ] ; then
#			usbreset "${MODEM_NAME}"
			gcom -d ${MODEM_DEVICE}
		fi
		ifup \'${MODEM_IFACE}\'
		exit 0
	else
		exit 0
	fi
fi 
