#!/bin/bash -v
MYSQL_ROOT_PASSWORD='secret123'
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
echo debconf mysql-server/root_password password $MYSQL_ROOT_PASSWORD | \
  debconf-set-selections
echo debconf mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD | \
  debconf-set-selections
apt-get -yqq install mysql-server
apt-get -yqq install apache2
systemctl enable apache2
systemctl start mysql
systemctl enable mysql
apt-get install -yqq php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl \
php7.0-mbstring php7.0-gd php7.0-xml php7.0-xmlrpc php7.0-intl php7.0-soap php7.0-zip
cd /var/www/html
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
rm latest.tar.gz
chown -R www-data:www-data /var/www/html/wordpress
mysql -u root -p --password=secret123 --execute="CREATE DATABASE wordpress_db;"
mysql -u root -p --password=secret123 --execute="GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'PASSWORD';"
mysql -u root -p --password=secret123 --execute="FLUSH PRIVILEGES;"
cd wordpress
mv wp-config-sample.php wp-config.php
sed -i 's/database_name_here/wordpress_db/g' wp-config.php
sed -i 's/username_here/wordpress_user/g' wp-config.php
sed -i 's/password_here/PASSWORD/g' wp-config.php
echo '<VirtualHost *:80>
ServerName mydomain.com
DocumentRoot /var/www/html/wordpress
ErrorLog ${APACHE_LOG_DIR}/mydomain.com_error.log
CustomLog ${APACHE_LOG_DIR}/mydomain.com_access.log combined
</VirtualHost>' > /etc/apache2/sites-available/mydomain.com.conf
ip=$(ip -4 addr show ens3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
sed -i "s/mydomain.com/$ip/g" /etc/apache2/sites-available/mydomain.com.conf
a2ensite mydomain.com.conf
systemctl start apache2 && service apache2 reload
systemctl restart mysql
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp core install --allow-root --url=$ip/ --title=Pentesting --admin_name=admin --skip-email \
--admin_email=admin@gmail.com --admin_password=admin123 --path=/var/www/html/wordpress
