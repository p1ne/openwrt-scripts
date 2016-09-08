#!/bin/sh

if [ ! -z $1 ] ; then
   which $1 > /dev/null 2>&1
   if [ $? -eq 1 ] ; then
      exit 1
   fi
fi
