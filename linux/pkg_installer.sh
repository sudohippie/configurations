#!/bin/bash

# global variables
set INSTALLS
set MANUAL_INSTALLS
set SUMMARY_BUFF

#helper methods
print_msg(){
	msg=$1
	printf "%s\n" "$msg"
}

print_newline(){
	print_msg ""
}

print_and_record_msg(){
	msg=$1
	print_msg "$msg"
	record_msg "$msg"
}

# append messages to the summary buffer
record_msg(){
	msg=$1$'\n'
	SUMMARY_BUFF+="$msg"
}

# installs the packages if the don't exist.
installs(){
	for pkg in "${INSTALLS[@]}"
	do
		skip="- SKIPPED, $pkg already exists."
		installed="* INSTALLED. $pkg."

		print_msg "---------------Processing $pkg---------------"

		# check whether the pkg is already installed
		is_installed=$(dpkg -s $pkg | grep -s "Status.* ok .*")
		
		if [ $? -eq 0 ];
		then
			# if installed, do nothing
			print_and_record_msg "$skip"
		else
			# if not installed, install package
			print_newline
			print_msg "Installing $pkg ..."

			# install the package
			# apt-get install $pkg

			print_newline
			print_and_record_msg "$installed"
		fi

	# have a space between next install
	print_newline

	done
}

# does not install any package. Defers installation
# to manual.
manual_installs(){
	for pkg in "${MANUAL_INSTALLS[@]}"
	do
		record_msg "+ MANUAL. $pkg"
	done
}

# declare all the package that must be 
# installed using the pacakge installer.
declare_installs(){
	INSTALLS=(
		"sysv-rc-conf" # service manager
		"vim" # text editor
		"wireshark" # wireshark networking
		"git" # git scm
	)
}

# declare all the package to be skipped 
# along with any additional message. 
declare_manual_installs(){
	MANUAL_INSTALLS=(
		"virtualbox, Install directly from www.virtualbox.org" # virtualbox
		"plexmediaserver, Install directly from plex.tv" # plex
		"intellij, Install directly from www.jetbrains.com" # intellij idea
		"jdk, Install directly from java.com. Also look at sudohippie.wordpress.com" # java jdk
	)
}

main(){
	# declare all the packages to be installed
	declare_installs

	# declare all the packages to be skipped
	declare_manual_installs

	# install all the package
	installs

	# manual install the package
	manual_installs

	# print summary report
	print_msg "############### SUMMARY ###############"
	print_msg "$SUMMARY_BUFF"
}

main 

# unset variables
unset INSTALLS
unset MANUAL_INSTALLS
unset SUMMARY_BUFF
