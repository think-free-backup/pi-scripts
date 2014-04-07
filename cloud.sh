#!/bin/bash

# http://www.raspbian.org/HexxehImages
# http://distribution.hexxeh.net/raspbian/raspbian-r3.zip
# user : root - password : hexxeh

# FUNCTIONS #################################################################################################

function installNode {

    echo "Installing nodejs"

    wget https://github.com/think-free/pi-packages/raw/master/nodejs_0.8.15-1_armhf.deb --no-check-certificate
    dpkg -i nodejs_0.8.15-1_armhf.de
}

# CORE ######################################################################################################

if [ "$#" -ne 1 ];
then

    echo "Please, change the default password (root:hexxeh)"
  
    echo "Preparing sdcard"
  
    echo "vm.min_free_kbytes = 8192" >> /etc/sysctl.conf
    echo "vm.swappiness=0" > /etc/sysctl.d/swap.conf
    apt-get purge
    apt-get autoremove
    sysctl -p /etc/sysctl.conf
    rm /etc/ssh/ssh_host_* && dpkg-reconfigure openssh-server
    apt-get update
    apt-get install ntp fake-hwclock vim
    echo "UTC" | sudo tee /etc/timezone
    sudo dpkg-reconfigure  --frontend noninteractive  tzdata
    apt-get install locales
    dpkg-reconfigure locales
    apt-get install console-setup keyboard-configuration
    dpkg-reconfigure keyboard-configuration
    apt-get update && apt-get dist-upgrade
    apt-get install ntpdate
    apt-get install curl
    ntpdate uk.pool.ntp.org
    rpi-update
fi

if [ "$1" == "database" ];
then

    echo "Installing database"

    apt-get install couchdb
    sed -i 's|127.0.0.1|0.0.0.0|' /etc/couchdb/default.ini
    /etc/init.d/couchdb restart

    # TODO : Install zeroconf script
fi

if [ "$1" == "cloud" ];
then

    installNode

    echo "Installing cloud"
    
    apt-get install prosody lua-sec
    cd /tmp
    wget http://easyrtc.com/files/easyrtc_server_example.zip
    cd /opt
    mkdir easyrtc
    cd easyrtc
    unzip easyrtc_server_example.zip
    npm install

fi

if [ "$1" == "wmr100" ];
then

    installNode
	
    echo "Installing wmr100"

    sudo apt-get install libusb-dev libzmq-dev
    wget --no-check-certificate https://github.com/think-free/pi-packages/raw/master/libhid-0.2.16-rpi.tar.gz
    tar xvf libhid-0.2.16-rpi.tar.gz
    cd libhid-0.2.16
    ./configure --prefix=/
    make
    sudo make install
    cd ..

    git clone https://github.com/barnybug/wmr100.git
    cd wmr100
    make

    wget --no-check-certificate https://raw.github.com/think-free/wmr100.js/master/wmr100.js

    # TODO : Install zeroconf script
fi

if [ "$1" == "media"];
then

    installNode

    echo "Installing media"

    sudo apt-get install mpd

    sudo apt-get install git-core autoconf automake libtool libpopt-dev

    mkdir src
    cd src
    git clone git://git.debian.org/collab-maint/svox.git svox-git
    cd svox-git
    git branch -a
    git checkout -f origin/debian-sid
    cd pico
    ./autogen.sh
    mkdir m4
    ./configure --prefix=/opt/svox-pico/
    make
    make install

fi
