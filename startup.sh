#!/bin/sh

service nginx start
service mysqld start

growthforecast.pl --data-dir "/root/GrowthForecast" --with-mysql "dbi:mysql:growthforecast:hostname=localhost"
