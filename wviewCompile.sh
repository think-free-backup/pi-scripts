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

# Getting dependencies

sudo apt-get install libgd2-xpm-dev libsqlite3-dev libcurl4-openssl-dev libusb-1.0-0-dev apache2 sqlite3 gawk bc libapache2-mod-php5 php5-cli php5-common php5-cgi

# Getting radlib dependency and compiling it

wget \"wget http://downloads.sourceforge.net/project/radlib/radlib/radlib-2.12.0/radlib-2.12.0.tar.gz\"
tar xvf radlib-2.12.0.tar.gz
cd radlib-2.12.0
./configure --enable-sqlite --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
make 
sudo checkinstall make install

# Getting wview and compiling it

wget \"http://garr.dl.sourceforge.net/project/wview/wview/wview-5.20.2/wview-5.20.2.tar.gz\"
tar xvf wview-5.20.2.tar.gz
cd wview-5.20.2
./configure --prefix=/ --bindir=/usr/bin --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib
make 
sudo checkinstall make install

# Init script

touch wview
echo "#!/bin/bash" >> wview
echo "" >> wview
echo "# add to the shared library search path" >> wview
echo "export LD_LIBRARY_PATH=/lib:/usr/local/lib:/usr/lib" >> wview
echo "CONF_DIRECTORY=/etc/wview" >> wview
echo "RUN_DIRECTORY=/var/lib/wview" >> wview
echo "WVIEW_INSTALL_DIR=/usr/bin" >> wview
echo "### BEGIN INIT INFO" >> wview
echo "# Provides:          wview" >> wview
echo "# Required-Start:    $local_fs $network $time $syslog" >> wview
echo "# Required-Stop:     $local_fs $network $time $syslog" >> wview
echo "# Default-Start:     2 3 4 5" >> wview
echo "# Default-Stop:      0 1 6" >> wview
echo "# Short-Description: Start wview daemons at boot time" >> wview
echo "# Description:       Start wview daemons at boot time." >> wview
echo "### END INIT INFO" >> wview
echo "# config:            $prefix/etc/wview" >> wview
echo "# pidfiles:          $prefix/var/wview/*.pid" >> wview
echo "################################################################################" >> wview
echo "" >> wview
echo "if [ -f $CONF_DIRECTORY/wview-user ]; then" >> wview
echo "  WVIEW_USER=`cat $CONF_DIRECTORY/wview-user`" >> wview
echo "fi" >> wview
echo ": ${WVIEW_USER:=root}" >> wview
echo "" >> wview
echo "WVIEWD_FILE=`cat $CONF_DIRECTORY/wview-binary`" >> wview
echo "WVIEWD_BIN=$WVIEW_INSTALL_DIR/$WVIEWD_FILE" >> wview
echo "test -x $WVIEWD_BIN || exit 5" >> wview
echo "" >> wview
echo "HTMLD_BIN=$WVIEW_INSTALL_DIR/htmlgend" >> wview
echo "test -x $HTMLD_BIN || exit 6" >> wview
echo "" >> wview
echo "FTPD_BIN=$WVIEW_INSTALL_DIR/wviewftpd" >> wview
echo "test -x $FTPD_BIN || exit 7" >> wview
echo "" >> wview
echo "SSHD_BIN=$WVIEW_INSTALL_DIR/wviewsshd" >> wview
echo "test -x $SSHD_BIN || exit 7" >> wview
echo "" >> wview
echo "ALARMD_BIN=$WVIEW_INSTALL_DIR/wvalarmd" >> wview
echo "test -x $ALARMD_BIN || exit 8" >> wview
echo "" >> wview
echo "CWOPD_BIN=$WVIEW_INSTALL_DIR/wvcwopd" >> wview
echo "test -x $CWOPD_BIN || exit 9" >> wview
echo "" >> wview
echo "HTTP_BIN=$WVIEW_INSTALL_DIR/wvhttpd" >> wview
echo "" >> wview
echo "RADROUTER_BIN=$WVIEW_INSTALL_DIR/radmrouted" >> wview
echo "" >> wview
echo "PMOND_BIN=$WVIEW_INSTALL_DIR/wvpmond" >> wview
echo "test -x $PMOND_BIN || exit 10" >> wview
echo "" >> wview
echo "RADROUTER_PID=$RUN_DIRECTORY/radmrouted.pid" >> wview
echo "WVIEWD_PID=$RUN_DIRECTORY/wviewd.pid" >> wview
echo "HTMLD_PID=$RUN_DIRECTORY/htmlgend.pid" >> wview
echo "FTPD_PID=$RUN_DIRECTORY/wviewftpd.pid" >> wview
echo "SSHD_PID=$RUN_DIRECTORY/wviewsshd.pid" >> wview
echo "ALARMD_PID=$RUN_DIRECTORY/wvalarmd.pid" >> wview
echo "CWOPD_PID=$RUN_DIRECTORY/wvcwopd.pid" >> wview
echo "HTTP_PID=$RUN_DIRECTORY/wvhttpd.pid" >> wview
echo "PMOND_PID=$RUN_DIRECTORY/wvpmond.pid" >> wview
echo "" >> wview
echo "wait_for_time_set() {" >> wview
echo "    THOUSAND=1000" >> wview
echo "    CURRVAL=`date +%s`" >> wview
echo "    while [ \"$CURRVAL\" -lt \"$THOUSAND\" ]; do" >> wview
echo "        sleep 1" >> wview
echo "        CURRVAL=`date +%s`" >> wview
echo "    done" >> wview
echo "}" >> wview
echo "" >> wview
echo "case \"$1\" in" >> wview
echo "  start)" >> wview
echo "	wait_for_time_set" >> wview
echo "" >> wview
echo "	echo \"Starting wview daemons:\"" >> wview
echo "   DAEMONLIST=\"RADROUTER WVIEWD HTMLD ALARMD CWOPD HTTP FTPD SSHD PMOND\"" >> wview
echo "   for each in $DAEMONLIST" >> wview
echo "   do" >> wview
echo "      BIN=$(eval echo \$$(echo $each)_BIN)" >> wview
echo "      PID=$(eval echo \$$(echo $each)_PID)" >> wview
echo "      if [ -x $BIN ]; then" >> wview
echo "         #echo $BIN exists " >> wview
echo "         if [ -f $PID ]; then" >> wview
echo "            #PIDfile exists; check to see if that PID is valid" >> wview
echo "            if [ ! -x /proc/$(cat $PID)/exe ]; then #if the pid is not current" >> wview
echo "               echo \"$BIN is not running but pid file exists, cleaning up\" " >> wview
echo "               rm $PID" >> wview
echo "            fi" >> wview
echo "         fi" >> wview
echo "         if [ $each = \"RADROUTER\" ]; then" >> wview
echo "            start-stop-daemon --start --oknodo --pidfile $PID \" >> wview
echo "               --chuid $WVIEW_USER --exec $BIN 1 $RUN_DIRECTORY" >> wview
echo "         else" >> wview
echo "	         start-stop-daemon --start --oknodo --pidfile $PID \" >> wview
echo "		      --exec $BIN --chuid $WVIEW_USER" >> wview
echo "         fi" >> wview
echo "         sleep 1 " >> wview
echo "      else" >> wview
echo "	      echo \"Cannot find $BIN - exiting!\"" >> wview
echo "	      exit 10" >> wview
echo "      fi" >> wview
echo "   done" >> wview
echo "" >> wview
echo "    ;;" >> wview
echo "  start-trace)" >> wview
echo "	echo \"Starting wview daemons (tracing to $RUN_DIRECTORY):\"" >> wview
echo "	echo \"Warning: traced processes run very slowly and may effect performance.\"" >> wview
echo "" >> wview
echo "	if [ -x $RADROUTER_BIN ]; then" >> wview
echo "		start-stop-daemon --start --oknodo --pidfile $RADROUTER_PID \" >> wview
echo "			--chuid $WVIEW_USER --exec $RADROUTER_BIN 1 $RUN_DIRECTORY" >> wview
echo "" >> wview
echo "	else" >> wview
echo "	    echo \"Cannot find $RADROUTER_BIN - exiting!\"" >> wview
echo "	    exit 10" >> wview
echo "	fi" >> wview
echo "	sleep 1" >> wview
echo "	strace -o $RUN_DIRECTORY/$WVIEWD_FILE.trace $WVIEWD_BIN -f &> /dev/null &" >> wview
echo "	sleep 1" >> wview
echo "	strace -o $RUN_DIRECTORY/htmlgend.trace $HTMLD_BIN -f &> /dev/null &" >> wview
echo "	strace -o $RUN_DIRECTORY/wvalarmd.trace $ALARMD_BIN -f &> /dev/null &" >> wview
echo "	strace -o $RUN_DIRECTORY/wvcwopd.trace $CWOPD_BIN -f &> /dev/null &" >> wview
echo "	strace -o $RUN_DIRECTORY/wvhttpd.trace $HTTP_BIN -f &> /dev/null &" >> wview
echo "	strace -o $RUN_DIRECTORY/wviewftpd.trace $FTPD_BIN -f &> /dev/null &" >> wview
echo "	strace -o $RUN_DIRECTORY/wviewsshd.trace $SSHD_BIN -f &> /dev/null &" >> wview
echo "	strace -o $RUN_DIRECTORY/wvpmond.trace $PMOND_BIN -f &> /dev/null &" >> wview
echo "	;;" >> wview
echo "  stop)" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $PMOND_PID \" >> wview
echo "		--exec $PMOND_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $HTTP_PID \" >> wview
echo "		--exec $HTTP_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $CWOPD_PID \" >> wview
echo "		--exec $CWOPD_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $ALARMD_PID \" >> wview
echo "		--exec $ALARMD_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $SSHD_PID \" >> wview
echo "		--exec $SSHD_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $FTPD_PID \" >> wview
echo "		--exec $FTPD_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $HTMLD_PID \" >> wview
echo "		--exec $HTMLD_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $WVIEWD_PID \" >> wview
echo "		--exec $WVIEWD_BIN --signal 15 --retry 5" >> wview
echo "	start-stop-daemon --stop --oknodo --pidfile $RADROUTER_PID \" >> wview
echo "		--exec $RADROUTER_BIN --signal 15 --retry 5" >> wview
echo "    ;;" >> wview
echo "  restart)" >> wview
echo "	$0 stop  && sleep 2" >> wview
echo "	$0 start" >> wview
echo "    ;;" >> wview
echo "  force-reload)" >> wview
echo "	$0 stop  && sleep 2" >> wview
echo "	$0 start" >> wview
echo "    ;;" >> wview
echo "  status)" >> wview
echo "	ps aux | grep \"wv\"" >> wview
echo "	ps aux | grep \"htmlgend\"" >> wview
echo "    ;;" >> wview
echo "  *)" >> wview
echo "	echo \"Usage: $0 {start|start-trace|stop|restart|force-reload|status}\"" >> wview
echo "	exit 1" >> wview
echo "esac" >> wview
echo "" >> wview
echo "exit 0" >> wview
sudo mv wview /etc/init.d/

sudo chmod +x /etc/init.d/wview
sudo update-rc.d wview defaults 99

# Web access

sudo ln -s /var/lib/wview/img/ /var/www/weather
sudo ln -s /var/lib/wviewmgmt/ /var/www/wviewmgmt
