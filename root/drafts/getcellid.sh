#!/bin/sh

. /root/variables.sh

while ! ping -c1 opencellid.org &>/dev/null; do :; done
cat | nc opencellid.org 80 << EOF
POST /cell/get/ HTTP/1.1
User-Agent: curl/7.26.0
Host: opencellid.org
Accept: */*
Content-Length: 90
Content-Type: application/x-www-form-urlencoded

key=${OPENCELLID_KEY}&mcc=250&mnc=01&lac=6330&cellid=53118&format=json
EOF
