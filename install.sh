#!/bin/bash
################################################################################
#
# Current modified by : Vaudois
# web: https://coinXpool.com
# Program:
#   Install Daemon Coin on Ubuntu 16.04/18.04
#   v0.1 (2022-07-17)
# 
################################################################################
	
	clear

	output() {
	printf "\E[0;33;40m"
	echo $1
	printf "\E[0m"
	}

	displayErr() {
	echo
	echo $1;
	echo
	exit 1;
	}

	#Add user group sudo + no password
	whoami=`whoami`
	sudo usermod -aG sudo ${whoami}
	echo '# yiimp
	# It needs passwordless sudo functionality.
	'""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
	' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

	 #Copy needed files
	cd
	cd $HOME/install_daemon_addport
	sudo mkdir -p $HOME/utils/conf

	FUNC=/etc/functions.sh
	if [[ ! -f "$FUNC" ]]; then
		sudo cp -r conf/functions.sh /etc/
	fi

	SCSCRYPT=/etc/screen-scrypt.sh
	if [[ ! -f "$SCSCRYPT" ]]; then
		sudo cp -r conf/screen-scrypt.sh /etc/
		sudo chmod +x /etc/screen-scrypt.sh
	fi

	SCSTRATUM=/etc/screen-stratum.sh
	if [[ ! -f "$SCSTRATUM" ]]; then
		sudo cp -r conf/screen-stratum.sh /etc/
	fi

	ADDPORTAPP=/usr/bin/addport
	if [[ ! -f "$ADDPORTAPP" ]]; then
		sudo cp -r utils/addport.sh /usr/bin/addport
		sudo chmod +x /usr/bin/addport
	fi

	EDITCONFAPP=/usr/bin/editconf.py
	if [[ ! -f "$EDITCONFAPP" ]]; then
		sudo cp -r conf/editconf.py /usr/bin/
		sudo chmod +x /usr/bin/editconf.py
	fi

	sudo cp -r conf/getip.sh $HOME/utils/conf

	source /etc/functions.sh

	term_art

	# Update package and Upgrade Ubuntu
	echo
	echo
	echo -e "$CYAN => Updating system and installing required packages :$COL_RESET"
	echo 
	sleep 3

	hide_output sudo apt -y update 
	hide_output sudo apt -y upgrade
	hide_output sudo apt -y autoremove
	hide_output sudo apt-get install -y software-properties-common
	hide_output sudo apt install -y dialog python3 python3-pip acl nano apt-transport-https figlet
	echo -e "$GREEN Done...$COL_RESET"

	source conf/prerequisite.sh
	sleep 3
	source conf/getip.sh

	echo
	echo
	echo -e "$RED Make sure you double check before hitting enter! Only one shot at these! $COL_RESET"
	echo
	read -e -p "enter path to stratum directory EX: /var/stratum : " path_stratum

	echo '
	#!/bin/sh
	PATH_STRATUM='"${path_stratum}"'
	' | sudo -E tee $HOME/utils/conf/info.sh >/dev/null 2>&1

	# Installing other needed files
	echo
	echo
	echo -e "$CYAN => Installing other needed files : $COL_RESET"
	echo
	sleep 3

	hide_output sudo apt-get -y install dialog acl libgmp3-dev libmysqlclient-dev libcurl4-gnutls-dev libkrb5-dev libldap2-dev libidn11-dev gnutls-dev \
	librtmp-dev sendmail mutt screen git make
	hide_output sudo apt -y install pwgen unzip
	echo -e "$GREEN Done...$COL_RESET"
	sleep 3

	# Installing Package to compile crypto currency
	echo
	echo
	echo -e "$CYAN => Installing Package to compile crypto currency $COL_RESET"
	echo
	sleep 3

	hide_output sudo apt-get -y install build-essential libzmq5 \
	libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev zlib1g-dev libz-dev \
	libseccomp-dev libcap-dev libminiupnpc-dev gettext libminiupnpc10 libcanberra-gtk-module libqrencode-dev libzmq3-dev \
	libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
	hide_output sudo add-apt-repository -y ppa:bitcoin/bitcoin
	hide_output sudo apt -y update && sudo apt -y upgrade
	hide_output sudo apt -y install libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++
	echo -e "$GREEN Done...$COL_RESET"

	# Installing Package to compile crypto currency
	echo
	echo
	echo -e "$CYAN => Installing additional system files required for daemons $COL_RESET"
	echo
	sleep 3

	echo -e "$YELLOW Installing additional system files required for daemons...$COL_RESET"
	hide_output sudo apt-get -y update
	hide_output sudo apt -y install build-essential libtool autotools-dev \
	automake pkg-config libssl-dev libevent-dev bsdmainutils git libboost-all-dev libminiupnpc-dev \
	libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev \
	protobuf-compiler libqrencode-dev libzmq3-dev libgmp-dev \
	cmake libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev \
	libpgm-dev libhidapi-dev libusb-1.0-0-dev libudev-dev libboost-chrono-dev libboost-date-time-dev libboost-filesystem-dev \
	libboost-locale-dev libboost-program-options-dev libboost-regex-dev libboost-serialization-dev libboost-system-dev libboost-thread-dev \
	python3 ccache doxygen graphviz default-libmysqlclient-dev libnghttp2-dev librtmp-dev libssh2-1 libssh2-1-dev libldap2-dev libidn11-dev libpsl-dev

	sudo mkdir -p $HOME/daemon_setup/tmp
	cd $HOME/daemon_setup/tmp
	echo -e "$GREEN Additional System Files Completed...$COL_RESET"

	echo
	echo -e "$YELLOW Building Berkeley 4.8, this may take several minutes...$COL_RESET"
	echo
	sleep 3
	sudo mkdir -p $HOME/utils/berkeley/db4/
	hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
	hide_output sudo tar -xzvf db-4.8.30.NC.tar.gz
	cd db-4.8.30.NC/build_unix/
	hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$HOME/utils/berkeley/db4/
	hide_output sudo make install
	cd $HOME/daemon_setup/tmp
	sudo rm -r db-4.8.30.NC.tar.gz db-4.8.30.NC
	echo -e "$GREEN Berkeley 4.8 Completed...$COL_RESET"

	echo
	echo -e "$YELLOW Building Berkeley 5.1, this may take several minutes...$COL_RESET"
	echo
	sleep 3
	sudo mkdir -p $HOME/utils/berkeley/db5/
	hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-5.1.29.tar.gz'
	hide_output sudo tar -xzvf db-5.1.29.tar.gz
	cd db-5.1.29/build_unix/
	hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$HOME/utils/berkeley/db5/
	hide_output sudo make install
	cd $HOME/daemon_setup/tmp
	sudo rm -r db-5.1.29.tar.gz db-5.1.29
	echo -e "$GREEN Berkeley 5.1 Completed...$COL_RESET"

	echo
	echo -e "$YELLOW Building Berkeley 5.3, this may take several minutes...$COL_RESET"
	echo
	sleep 3
	sudo mkdir -p $HOME/utils/berkeley/db5.3/
	hide_output sudo wget 'http://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz'
	hide_output sudo tar -xzvf db-5.3.28.tar.gz
	cd db-5.3.28/build_unix/
	hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$HOME/utils/berkeley/db5.3/
	hide_output sudo make install
	cd $HOME/daemon_setup/tmp
	sudo rm -r db-5.3.28.tar.gz db-5.3.28
	echo -e "$GREEN Berkeley 5.3 Completed...$COL_RESET"

	echo
	echo -e "$YELLOW Building Berkeley 6.2, this may take several minutes...$COL_RESET"
	echo
	sleep 3
	sudo mkdir -p $HOME/utils/berkeley/db6.2/
	hide_output sudo wget 'http://download.oracle.com/berkeley-db/db-6.2.23.tar.gz'
	hide_output sudo tar -xzvf db-6.2.23.tar.gz
	cd db-6.2.23/build_unix/
	hide_output sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$HOME/utils/berkeley/db6.2/
	hide_output sudo make install
	cd $HOME/daemon_setup/tmp
	sudo rm -r db-6.2.23.tar.gz db-6.2.23
	echo -e "$GREEN Berkeley 6.2 Completed...$COL_RESET"

	echo
	echo -e "$YELLOW Building OpenSSL 1.0.2g, this may take several minutes...$COL_RESET"
	echo
	sleep 3
	cd $HOME/daemon_setup/tmp
	hide_output sudo wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2g.tar.gz --no-check-certificate
	hide_output sudo tar -xf openssl-1.0.2g.tar.gz
	cd openssl-1.0.2g
	hide_output sudo ./config --prefix=$HOME/utils/openssl --openssldir=$HOME/utils/openssl shared zlib
	hide_output sudo make
	hide_output sudo make install
	cd $HOME/daemon_setup/tmp
	sudo rm -r openssl-1.0.2g.tar.gz openssl-1.0.2g
	echo -e "$GREEN OpenSSL 1.0.2g Completed...$COL_RESET"

	echo
	echo -e "$YELLOW Building bls-signatures, this may take several minutes...$COL_RESET"
	echo
	sleep 3
	cd $HOME/daemon_setup/tmp
	hide_output sudo wget 'https://github.com/codablock/bls-signatures/archive/v20181101.zip'
	hide_output sudo unzip v20181101.zip
	cd bls-signatures-20181101
	hide_output sudo cmake .
	hide_output sudo make install
	cd $HOME/daemon_setup/tmp
	sudo rm -r v20181101.zip bls-signatures-20181101
	echo -e "$GREEN bls-signatures Completed...$COL_RESET"
	
	echo
	echo
	echo -e "$GREEN Done...$COL_RESET"

	# Update Timezone
	echo
	echo
	echo -e "$CYAN => Update default timezone. $COL_RESET"
	echo

	echo -e " Setting TimeZone to UTC...$COL_RESET"
	if [ ! -f /etc/timezone ]; then
	echo "Setting timezone to UTC."
	echo "Etc/UTC" > sudo /etc/timezone
	sudo systemctl restart rsyslog
	fi
	sudo systemctl status rsyslog | sed -n "1,3p"
	echo
	echo -e "$GREEN Done...$COL_RESET"
	sleep 3

	# Install Daemonbuilder
	echo
	echo
	echo -e "$CYAN => Install DaemonBuilder Coin. $COL_RESET"
	echo

	echo -e "$CYAN => Installing DaemonBuilder $COL_RESET"
	cd $HOME/daemon_install_script
	sudo mkdir -p $HOME/utils/daemon_builder
	sudo cp -r utils/start.sh $HOME/utils/daemon_builder
	sudo cp -r utils/menu.sh $HOME/utils/daemon_builder
	sudo cp -r utils/menu2.sh $HOME/utils/daemon_builder
	sudo cp -r utils/menu3.sh $HOME/utils/daemon_builder
	sudo cp -r utils/errors.sh $HOME/utils/daemon_builder
	sudo cp -r utils/source.sh $HOME/utils/daemon_builder
	sudo cp -r utils/upgrade.sh $HOME/utils/daemon_builder
	sudo cp -r utils/stratum.sh $HOME/utils
	sleep 3
	echo '
	#!/usr/bin/env bash
	source /etc/functions.sh # load our functions
	cd $HOME/utils/daemon_builder
	bash start.sh
	cd ~
	' | sudo -E tee /usr/bin/daemonbuilder >/dev/null 2>&1
	sudo chmod +x /usr/bin/daemonbuilder
	echo
	echo -e "$GREEN Done...$COL_RESET"
	sleep 3


	# Final Directory permissions
	echo
	echo
	echo -e "$CYAN => Final Directory permissions $COL_RESET"
	echo
	sleep 3

	whoami=`whoami`

	#Add to contrab screen-scrypt
	(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /etc/screen-scrypt.sh") | crontab -
	(crontab -l 2>/dev/null; echo "@reboot sleep 20 && /etc/screen-stratum.sh") | crontab -
	sleep 3

	#Misc
	sudo rm -rf $HOME/install_daemon_addport

	#Restart service
	sudo systemctl restart cron.service

	echo
	echo -e "$GREEN Done...$COL_RESET"
	sleep 3

	echo
	install_end_message
	echo
	echo
	cd ~
