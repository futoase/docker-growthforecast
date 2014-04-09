#!/bin/sh

service nginx start
service mysqld start
service ntpd start
service sshd start

if [ ! -d /var/lib/mysql/growthforecast ]; then
  /home/growthforecast/scripts/mysqld-setup.sh
fi

# setup timezone
/home/growthforecast/scripts/timezone.sh

/usr/bin/supervisord
