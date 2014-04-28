#!/bin/bash

SCRIPT_VERSION=0.1

## CASE: HELP ARGUMENT
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: `basename $0` [OPTION]"
  echo "   -h, --help: displays this help message"
  echo "   -v: takes version info"
  echo "   -a, --about: displays information about the script"
  exit 0
## CASE: VERSION ARGUMENT
elif [ "$1" == "-v" ]; then
  while getopts v:b option
    do
       case "${option}"
       in
            v) VERSION=${OPTARG};;
       esac
  done
## CASE: ABOUT ARGUMENT
elif [ "$1" == "-a" ] || [ "$1" == "--about" ]; then
  echo "package (Flashback) v${SCRIPT_VERSION}"
  echo "License GPLv3: GNU version 3 <http://gnu.org/licenses/gpl.html>."
  echo "This is free software: you are free to change and redistribute it."
  echo "There is NO WARRANTY, to the extent permitted by law."
  echo
  echo "Written by Nekhelesh Ramananthan"
  exit 0
## CASE: INVALID ARGUMENT
else
 echo "Invalid Argument."
 exit 0
fi

echo "Flashback - Package Deb Script v${SCRIPT_VERSION}"

## SCRIPT VARIABLES
RELEASE_DIR=../releases/flashback/v$VERSION-deb
SOURCE_CHANGE=flashback_${VERSION}_source.changes

## CREATE PRE-REQUISITE RELEASE FOLDER
mkdir -p ../releases/flashback

## COPY SOURCE CODE TO RELEASE FOLDER
cp . $RELEASE_DIR -r
cd $RELEASE_DIR

## CLEAN RELEASE FOLDER CODE
sudo rm .git* .excludes *.*~ package.sh package-click.sh design.jpg README.md *.qmlproject.user -r -f

## PREPARE CODE FOR DEB PKG
sed -i "s/@APP_VERSION@/${VERSION}/g" Flashback.qml 
mv flashback-deb.desktop Flashback.desktop
mv flashback-shadowed.png flashback.png

## BUILD DEB PKG
debuild -us -uc
debuild -S -sa

## PUSH DEB PKG TO PPA
cd ..
dput ppa:ubuntu-touch-community-dev/ppa $SOURCE_CHANGE
