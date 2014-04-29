#!/bin/bash

clean_root() {
	echo "[PACKAGE]: Removing common files"
	sudo rm .git* .excludes *.*~ package.sh design.jpg README.md *.qmlproject.user -r -f
}

prep_deb() {
	echo "[PACKAGE]: Preparing folder for debian packaging"
	cp . $1 -r
	cd $1
	clean_root
	sed -i "s/@APP_VERSION@/${2}/g" Flashback.qml 
	mv flashback-deb.desktop Flashback.desktop
	mv flashback-shadowed.png flashback.png
}

prep_click() {
	echo "[PACKAGE]: Preparing folder for click packaging"
	cp . $1 -r
	cd $1
	clean_root
	sudo rm debian flashback-deb.desktop flashback-shadowed.png -r -f
	sed -i "s/@APP_VERSION@/${2}/g" Flashback.qml 
	sed -i "s/@APP_VERSION@/${2}/g" manifest.json
}

# Function to build the deb and upload to PPA
build_deb() {
	echo "[PACKAGE]: Building Debian Package"
	debuild -us -uc
	debuild -S -sa
	echo "[PACKAGE]: Uploading to Ubuntu Touch Community Dev PPA"
	cd ..
	#dput ppa:ubuntu-touch-community-dev/ppa $1	 
}

# Function to build the click package
build_click() {
	echo "[PACKAGE]: Building Click Package"
	cd ..
	click build $1	
}

#CASE: HELP ARGUMENT
if [ "$1" == "-h" ]; then
	echo "Usage: `basename $0` -[OPTION 1] value -[OPTION 2] value"
	echo "   -v: pkg version [REQUIRED]"
	echo "   -f: pkg format (deb,click,all) [REQUIRED]"
	echo "   -h: displays this help message"	
	echo "   -a: displays information about the script"
	exit 0

#CASE: ABOUT ARGUMENT
elif [ "$1" == "-a" ]; then
	echo "package (Flashback) v0.1"
	echo "License GPLv3: GNU version 3 <http://gnu.org/licenses/gpl.html>."
	echo "This is free software: you are free to change and redistribute it."
	echo "There is NO WARRANTY, to the extent permitted by law."
	echo
	echo "Written by Nekhelesh Ramananthan"
	exit 0

#CASE: VERSION ARGUMENT
elif [ "$1" == "-v" ] || [ "$1" == "-f" ]; then
	while getopts v:f: option
		do
			case "${option}"
			in
				v) VERSION=${OPTARG};;
				f) FORMAT=${OPTARG};;
			esac
		done
	
	## PREPARATORY STEPS
	RELEASE_DIR=../releases/flashback/v$VERSION
	SOURCE_CHANGE=flashback_${VERSION}_source.changes
	mkdir -p ../releases/flashback

	if [ $FORMAT == "deb" ]; then
		prep_deb $RELEASE_DIR-deb $VERSION
		build_deb $SOURCE_CHANGE

	elif [ $FORMAT == "click" ]; then
		prep_click $RELEASE_DIR $VERSION
		build_click v$VERSION

	elif [ $FORMAT == "all" ]; then
		prep_deb $RELEASE_DIR-deb $VERSION
		cd -
		prep_click $RELEASE_DIR $VERSION
		cd -
		cd $RELEASE_DIR-deb
		build_deb $SOURCE_CHANGE
		cd v$VERSION
		build_click v$VERSION

	else
		echo "Invalid pkg format."
	fi

	exit 0

## CASE: INVALID ARGUMENT
else
	echo "Invalid Argument."
	exit 0
fi
