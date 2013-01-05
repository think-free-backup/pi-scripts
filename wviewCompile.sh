#!/bin/bash

#/* **************************************************************** 
# *
# *  Description : This script allow you to compile wview
# *                the weather station program
# *  License :     All the sources are available under the GPL v3
# *                http://www.gnu.org/licenses/gpl.html
# *  Author : Christophe Meurice
# *  
# *  (C) Meurice Christophe 2012
# *
# ****************************************************************** */

######################################################################################
# New version
######################################################################################

sudo apt-get install --yes build-essential zlib1g-dev libpng12-dev libreadline-dev gawk libsqlite3-dev sqlite3 libgd2-xpm libgd2-xpm-dev libssl-dev sendmail sendemail libcurl4-openssl-dev libusb-1.0-0 libusb-1.0-0-dev apache2 php5 php5-sqlite libapache2-mod-php5 ntp tnftp wget

wget http://downloads.sourceforge.net/project/radlib/radlib/radlib-2.12.0/radlib-2.12.0.tar.gz

tar zxvf radlib-2.12.0.tar.gz
cd radlib-2.12.0
./configure --enable-sqlite --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
sudo make install
cd ..

wget http://garr.dl.sourceforge.net/project/wview/wview/wview-5.20.2/wview-5.20.2.tar.gz
tar zxvf wview-5.20.2.tar.gz
cd wview-5.20.2
./configure --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
sudo make install
cd ..

sudo wget --no-check-certificate https://raw.github.com/think-free/pi-scripts/master/wview-init-script -O /etc/init.d/wview
sudo chmod +x /etc/init.d/wview
sudo update-rc.d wview defaults 99
sudo ln -s /var/lib/wview/img/ /var/www/weather
sudo ln -s /var/lib/wviewmgmt/ /var/www/wviewmgmt

exit 0

######################################################################################
# Older version
######################################################################################

# Getting dependencies

sudo apt-get update
sudo apt-get install libgd2-xpm-dev libsqlite3-dev libcurl4-openssl-dev libusb-1.0-0-dev apache2 sqlite3 gawk bc libapache2-mod-php5 php5-cli php5-common php5-cgi

# Getting radlib dependency and compiling it

wget "http://downloads.sourceforge.net/project/radlib/radlib/radlib-2.12.0/radlib-2.12.0.tar.gz"
tar xvf radlib-2.12.0.tar.gz
cd radlib-2.12.0
./configure --enable-sqlite --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
make 
sudo make install

# Getting wview and compiling it

wget "http://garr.dl.sourceforge.net/project/wview/wview/wview-5.20.2/wview-5.20.2.tar.gz"
tar xvf wview-5.20.2.tar.gz
cd wview-5.20.2
./configure --prefix=/ 
make 
sudo make install

# Web access

sudo ln -s /var/lib/wview/img/ /var/www/weather
sudo ln -s /var/lib/wviewmgmt/ /var/www/wviewmgmt
