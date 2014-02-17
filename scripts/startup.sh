#!/bin/sh

service nginx start
service mysqld start
service ntpd start
service iptables stop

if [ ! -d /var/lib/mysql/growthforecast ]; then
  /home/growthforecast/scripts/mysqld-setup.sh
fi

# setup timezone
/home/growthforecast/scripts/timezone.sh

/usr/bin/supervisord
