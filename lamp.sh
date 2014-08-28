#!/usr/bin/env bash
echo "************************************************************"
echo "****************** Let's get start *************************"
echo "************************************************************"


echo "-- At first update --"
sudo apt-get update

echo "*** MySQL config ***"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password passwd'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password passwd'

echo "*** Installing base packages - ***"
sudo apt-get install -y vim curl python-software-properties 

echo "*** Installing apache2  ***"
sudo apt-get install -y apache2

cat << EOF | sudo tee -a /etc/apache2/apache2.conf
Servername localhost
EOF

echo "*** Installing php5  ***"
sudo apt-get install -y php5 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt git-core

echo "*** Installing MySQL  ***"
sudo apt-get install -y mysql-server

echo "*** Installing and configuring Xdebug  ***"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "*** Some configurations on server  ***"
sudo php5enmod mcrypt
sudo a2enmod rewrite

echo "*** Turning on error reports  ***"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "*** Setting document root  ***"
# sudo ln -fs /home/vagrant/www /var/www/html
VHOST=$(cat <<EOF
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot "/var/www"  
  <Directory "/var/www">
    AllowOverride All
  </Directory>
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf 

echo "*** Deleting default html folder from document root ***"
sudo rm -rf /var/www/html

echo "*** Restarting apache  ***"
sudo service apache2 restart

echo "*** Installing phpmyadmin ***"
if [ ! -f /etc/phpmyadmin/config.inc.php ];
then

	# Used debconf-get-selections to find out what questions will be asked
	# This command needs debconf-utils

	# Handy for debugging. clear answers phpmyadmin: echo PURGE | debconf-communicate phpmyadmin

	echo 'phpmyadmin phpmyadmin/dbconfig-install boolean false' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

	echo 'phpmyadmin phpmyadmin/app-password-confirm password passwd' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/mysql/admin-pass password passwd' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/password-confirm password passwd' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/setup-password password passwd' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/database-type select mysql' | debconf-set-selections
	echo 'phpmyadmin phpmyadmin/mysql/app-pass password passwd' | debconf-set-selections
	
	echo 'dbconfig-common dbconfig-common/mysql/app-pass password passwd' | debconf-set-selections
	echo 'dbconfig-common dbconfig-common/password-confirm password passwd' | debconf-set-selections
	echo 'dbconfig-common dbconfig-common/app-password-confirm password passwd' | debconf-set-selections
	echo 'dbconfig-common dbconfig-common/app-password-confirm password passwd' | debconf-set-selections
	echo 'dbconfig-common dbconfig-common/password-confirm password passwd' | debconf-set-selections
	
	sudo apt-get -y install phpmyadmin
fi

echo "************************************************************"
echo "****************** LAMP is ready  **************************"
echo "************************************************************"
