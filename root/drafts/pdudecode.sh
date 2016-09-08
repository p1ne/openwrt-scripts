#!/bin/sh

#in=C2303BEC1E977535184C0E02

in=$1
b=0
d=0

i=1

len=`expr length $in`

while [ $i -lt $len ] ; do
    ss=`echo $in | cut -c $i,$((i+1))`
    byte=0x$ss
        
    c=$(( (( byte & ((1 << 7-d)-1)) << d) | b ))
    b=$(( byte >> (7 - d) ))
                
    printf "\x$(printf %x $c)"
                    
    d=$((d+1))
                        
    if [ $d -eq 7 ] ; then
       printf "\x$(printf %x $b)"
       d=0
       b=0
    fi
    i=$((i+2))
done
echo ""

