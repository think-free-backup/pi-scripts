#!/bin/bash

# http://www.raspbian.org/HexxehImages
# http://distribution.hexxeh.net/raspbian/raspbian-r3.zip
# user : root - password : hexxeh

echo "Please, change the default password (root:hexxeh)"

echo "Preparing sdcard"

echo "vm.min_free_kbytes = 8192" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
rm /etc/ssh/ssh_host_* && dpkg-reconfigure openssh-server
apt-get update
apt-get install ntp fake-hwclock vim
dpkg-reconfigure tzdata
apt-get install locales
dpkg-reconfigure locales
apt-get install console-setup keyboard-configuration
dpkg-reconfigure keyboard-configuration
apt-get update && apt-get dist-upgrade
apt-get install ntpdate
ntpdate uk.pool.ntp.org
rpi-update

echo "Installing database"

apt-get install couchdb
sed -i 's|127.0.0.1|0.0.0.0|' /etc/couchdb/default.ini
/etc/init.d/couchdb restart

echo "Installing nodejs"

wget https://github.com/think-free/pi-packages/raw/master/nodejs_0.8.15-1_armhf.deb --no-check-certificate
sudo dpkg -i nodejs_0.8.15-1_armhf.de
