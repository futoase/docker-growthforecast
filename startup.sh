#!/bin/sh

service nginx start
service mysqld start

MYSQL_USER=growthforecast MYSQL_PASSWORD=growthforecast growthforecast.pl --data-dir "/root/GrowthForecast" --with-mysql "dbi:mysql:growthforecast:hostname=localhost"
