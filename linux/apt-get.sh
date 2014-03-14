#!/bin/sh

install(){
	pkg=$1
	apt-get install $pkg
	dpkg -s $pkg | grep Status
	echo "* Complete. Package $pkg installed."
	echo
}

skip(){
	pkg=$1
	msg=$2
	echo "- Skipped $pkg. $msg."
	echo
}

# Manage services
# sysv-rc-conf 
install "sysv-rc-conf"

# Editors
# vim
install "vim"

# Wireshark
install "wireshark"

# Git
install "git"

# Virtualbox
# apt-get install virtualbox
skip "virtualbox" "Install directly from www.virtualbox.org"

# Plex media server
skip "plexmediaserver" "Install directly from plex.tv"
