#!/bin/bash

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

