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

    apt-get install -y mpd
    apt-get install -y nfs-common
    apt-get install -y git-core autoconf automake libtool libpopt-dev build-essential

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
    
    cp /etc/mpd.conf /etc/mpd.conf_save
    echo '## MPD Configuration file' > /etc/mpd.conf
    echo '' >> /etc/mpd.conf
    echo 'music_directory         "/mnt/media/Music"' >> /etc/mpd.conf
    echo 'playlist_directory              "/var/lib/mpd/playlists"' >> /etc/mpd.conf
    echo 'db_file                 "/var/lib/mpd/tag_cache"' >> /etc/mpd.conf
    echo 'log_file                        "/var/log/mpd/mpd.log"' >> /etc/mpd.conf
    echo 'pid_file                        "/var/run/mpd/pid"' >> /etc/mpd.conf
    echo 'state_file                      "/var/lib/mpd/state"' >> /etc/mpd.conf
    echo 'sticker_file                   "/var/lib/mpd/sticker.sql"' >> /etc/mpd.conf
    echo 'bind_to_address         "0.0.0.0"' >> /etc/mpd.conf
    echo 'port                            "6600"' >> /etc/mpd.conf
    echo 'log_level                       "default"' >> /etc/mpd.conf
    echo 'auto_update    "yes"' >> /etc/mpd.conf
    echo 'follow_outside_symlinks "yes"' >> /etc/mpd.conf
    echo 'follow_inside_symlinks          "yes"' >> /etc/mpd.conf
    echo 'zeroconf_enabled                "yes"' >> /etc/mpd.conf
    echo 'zeroconf_name                   "Music Player"' >> /etc/mpd.conf
    echo 'filesystem_charset              "UTF-8"' >> /etc/mpd.conf
    echo 'id3v1_encoding                  "UTF-8"' >> /etc/mpd.conf
    echo '' >> /etc/mpd.conf
    echo 'input {' >> /etc/mpd.conf
    echo '        plugin "curl"' >> /etc/mpd.conf
    echo '}' >> /etc/mpd.conf
    echo '' >> /etc/mpd.conf
    echo 'audio_output {' >> /etc/mpd.conf
    echo '        type            "alsa"' >> /etc/mpd.conf
    echo '        name            "My ALSA Device"' >> /etc/mpd.conf
    echo '        device          "hw:0,0"        # optional' >> /etc/mpd.conf
    echo '        format          "44100:16:2"    # optional' >> /etc/mpd.conf
    echo '        mixer_device    "default"       # optional' >> /etc/mpd.conf
    echo '        mixer_control   "PCM"           # optional' >> /etc/mpd.conf
    echo '        mixer_index     "0"             # optional' >> /etc/mpd.conf
    echo '}' >> /etc/mpd.conf
    echo '' >> /etc/mpd.conf
    echo 'audio_output {' >> /etc/mpd.conf
    echo '        type            "httpd"' >> /etc/mpd.conf
    echo '        name            "My HTTP Stream"' >> /etc/mpd.conf
    echo '        encoder         "lame"          # optional, vorbis or lame' >> /etc/mpd.conf
    echo '        port            "8000"' >> /etc/mpd.conf
    echo '        #quality                "5.0"                   # do not define if bitrate is defined' >> /etc/mpd.conf
    echo '        bitrate         "128"                   # do not define if quality is defined' >> /etc/mpd.conf
    echo '        format          "22050:16:1"' >> /etc/mpd.conf
    echo '}' >> /etc/mpd.conf   
    mkdir -p /mnt/media
    
fi
