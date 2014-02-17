#!/bin/sh

rm -f /etc/localtime

if [ "${TIME_ZONE}" = "tokyo" ]; then
  cp /usr/share/zoneinfo/Japan /etc/localtime
else
  cp /usr/share/zoneinfo/UTC /etc/localtime
fi
