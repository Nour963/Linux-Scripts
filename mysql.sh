#!/bin/bash
#configure mysql and provision it
export MYPWD="Hello123?";
sudo mysql_secure_installation 2>/dev/null <<MSI
n
y
${MYPWD}
${MYPWD}
y
y
y
y

MSI
mysql -u root -p${MYPWD} -e "SELECT 1+1";

sudo mysql -u root -pHello123?  <<MSI2
create database vagrant;
CREATE USER 'nour'@'%' IDENTIFIED BY 'Hello123?';
GRANT ALL PRIVILEGES ON *.* TO 'nour'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
MSI2
