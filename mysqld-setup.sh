#!/bin/sh

service mysqld start
chkconfig --level 2345 mysqld on

mysqladmin -h localhost -u root create growthforecast
sleep 10s

mysql -u root -e "GRANT CREATE, ALTER, DELETE, INSERT, UPDATE, SELECT ON growthforecast.* TO 'growthforecast'@'localhost' IDENTIFIED BY 'growthforecast';"
sleep 10s
