#!/usr/bin/env bash
echo "************************************************************"
echo "******* Starting to install  necessary softwares ***********"
echo "************************************************************"

echo "*** At first update ***"
sudo apt-get update


echo "*** Installing composer ***"
echo "*************************************************************"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer


echo "*** Installing nodejs ***"
echo "*************************************************************"
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs

echo "*** Installing grunt ***"
sudo npm install -y -g grunt-cli

echo "*** Installing yeoman ***"
sudo npm install -y -g yo
sudo npm install -y -g generator-angular


echo "*** Installing lineman ***"
sudo npm install -y -g lineman

echo "*** Installing bower ***"
sudo npm install -y -g bower

echo "*** Installing coffee-script ***"
sudo npm install -y -g coffee-script


echo "*** Installing ruby 2.x ***"
echo "************************************************************"
sudo add-apt-repository -y ppa:brightbox/ruby-ng-experimental
sudo apt-get update
sudo apt-get install -y ruby2.1 
sudo apt-get install -y ruby2.1-dev

echo "*** Install sass and some plugins ***"
sudo gem install compass --pre
sudo gem install susy --pre

echo "*** We are going to your web root directory ***"
cd /var/www/html

echo "************************************************************"
echo "*************** Everythings are done. **********************"
echo "****************** Congratulation! *************************"
echo "*************** Hooray Hooray Hooray ***********************"
echo "************************************************************"



