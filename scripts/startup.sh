#!/bin/sh

service nginx start
service mysqld start
service ntpd start

if [ ! -d /var/lib/mysql/growthforecast ]; then
  /home/growthforecast/scripts/mysqld-setup.sh
fi

/usr/bin/supervisord
