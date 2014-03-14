#!/bin/sh

install(){
	pkg=$1
	apt-get install $pkg
	echo "* Complete. Package $pkg installed."
}

skip(){
	pkg=$1
	msg=$2
	echo "- Skipping $pkg. $msg."
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
