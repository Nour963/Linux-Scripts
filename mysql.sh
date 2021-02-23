#!/bin/bash
#configure mysql on centos and provision it
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
#########################################################################################

##configure mysql on UBUNTU16 and provision it
MYSQL_ROOT_PASSWORD='D33Ps3CR3T?'
#echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections #in case you're in a non-interractive shell
echo debconf mysql-server/root_password password $MYSQL_ROOT_PASSWORD | \
  debconf-set-selections
echo debconf mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD | \
  debconf-set-selections
apt-get -yqq install mysql-server > /dev/null 
apt-get -yqq install expect > /dev/null
tee ~/secure_our_mysql.sh > /dev/null << EOF
spawn $(which mysql_secure_installation)

expect "Enter password for user root:"
send "$MYSQL_ROOT_PASSWORD\r"

expect "Press y|Y for Yes, any other key for No:"
send "N\r"

expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
send "N\r"

expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
send "y\r"

EOF
expect ~/secure_our_mysql.sh
rm -v ~/secure_our_mysql.sh
mysql -u root -p --password=D33Ps3CR3T? --execute="update user set authentication_string='' where User='root';flush privileges;" mysql
/etc/init.d/mysql stop
/etc/init.d/mysql start
mysql -u root --execute="uninstall plugin validate_password;"

