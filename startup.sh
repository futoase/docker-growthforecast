#!/bin/sh

service nginx start
service mysqld start

if [ ! -d /var/lib/mysql/growthforecast ]; then
  /root/mysqld-setup.sh
fi

growthforecast.pl --data-dir "/root/GrowthForecast" --with-mysql "dbi:mysql:growthforecast:hostname=localhost"
