#!/bin/bash

# http://www.raspbian.org/HexxehImages
# http://distribution.hexxeh.net/raspbian/raspbian-r3.zip
# user : root - password : hexxeh

# FUNCTIONS #################################################################################################

function installNode {

    echo "Installing nodejs"
    
    apt-get install python

    curl -L --output nodejs_0.8.15-1_armhf.deb https://github.com/think-free/pi-packages/raw/master/nodejs_0.8.15-1_armhf.deb
    dpkg -i nodejs_0.8.15-1_armhf.deb
    
    # TODO : Add user node
    
    cd /opt
    git clone https://github.com/think-free/monitor.git
    cd monitor
    chmod +x scripts/install
    ./scripts/install
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
    apt-get install ca-certificates
    apt-get install libgnutls28 libgnutlsxx28 libgnutls-dev gnutls-dev
    apt-get install ntp fake-hwclock vim git-core
    echo "UTC" | tee /etc/timezone
    dpkg-reconfigure  --frontend noninteractive  tzdata
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

    apt-get install libusb-dev libzmq-dev
    wget --no-check-certificate https://github.com/think-free/pi-packages/raw/master/libhid-0.2.16-rpi.tar.gz
    tar xvf libhid-0.2.16-rpi.tar.gz
    cd libhid-0.2.16
    ./configure --prefix=/
    make
    make install
    cd ..

    git clone https://github.com/barnybug/wmr100.git
    cd wmr100
    make

    wget --no-check-certificate https://raw.github.com/think-free/wmr100.js/master/wmr100.js

    # TODO : Install zeroconf script
fi

if [ "$1" == "media" ];
then

    installNode

    echo "Installing media"
    
    echo "snd_bcm2835" >> /etc/modules

    apt-get install mpd

    apt-get install git-core autoconf automake libtool libpopt-dev build-essential

    cd
    mkdir src
    cd src
    git clone git://git.debian.org/collab-maint/svox.git svox-git
    cd svox-git
    git branch -a
    git checkout -f remotes/origin/debian-sid
    cd pico
    ./autogen.sh
    mkdir m4
    ./configure --prefix=/opt/svox-pico/
    make
    make install
    
    echo '#!/bin/bash' > /opt/svox-pico/say
    echo "" >> /opt/svox-pico/say
    echo 'PT=/opt/svox-pico/bin' >> /opt/svox-pico/say
    echo 'LG=$2' >> /opt/svox-pico/say
    echo "" >> /opt/svox-pico/say
    echo 'FILE=$RANDOM' >> /opt/svox-pico/say
    echo '$PT/pico2wave -l=$LG -w=/tmp/$FILE.wav "$1"' >> /opt/svox-pico/say
    echo 'aplay /tmp/$FILE.wav' >> /opt/svox-pico/say
    echo 'rm /tmp/$FILE.wav' >> /opt/svox-pico/say
    echo "" >> /opt/svox-pico/say
    
    
    
    chmod +x /opt/svox-pico/say
    
    cd /srv
    git clone https://github.com/think-free/say.git
    cd say
    npm install
fi
