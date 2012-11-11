#!/bin/bash

		
#/* **************************************************************** 
# *
# *  Description : This script clean the debian image for a headless
# *                installation
# *  License :     All the sources are available under the GPL v3
# *                http://www.gnu.org/licenses/gpl.html
# *  Author : Christophe Meurice
# *  
# *  (C) Meurice Christophe 2012
# *
# ****************************************************************** */

sudo apt-get --yes purge xserver* x11-common x11-utils x11-xkb-utils x11-xserver-utils xarchiver xauth xkb-data console-setup xinit lightdm libx{composite,cb,cursor,damage,dmcp,ext,font,ft,i,inerama,kbfile,klavier,mu,pm,randr,render,res,t,xf86}* lxde* lx{input,menu-data,panel,polkit,randr,session,session-edit,shortcut,task,terminal} obconf openbox gtk* libgtk* nano python-pygame python-tk python3-tk scratch tsconf xdg-tools desktop-file-utils
sudo rm /usr/lib/xorg/modules/linux /usr/lib/xorg/modules/extensions /usr/lib/xorg/modules /usr/lib/xorg -r
sudo apt-get --yes autoremove
sudo apt-get --yes autoclean
sudo apt-get --yes clean
