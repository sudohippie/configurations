#!/bin/sh

copy(){
	local src=$1
	local dest=$2

	if [ -f $dest ];
	then
		echo "- Aborted. File $dest exists."
	else
		cp -r $src $dest
		echo "* Copied. File $src to $dest"
	fi
}

# Copy .bashrc file
copy "linux/_bashrc" "${HOME}/.bashrc"

# Copy .gitconfig file
copy "git/_gitconfig" "${HOME}/.gitconfig"
