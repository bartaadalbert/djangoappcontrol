#!/bin/bash
#usage APP NAME
APP_NAME=$1
RED='\033[0;31m'
#LINUX
SED=$(which sed)
#MACOS, brew install gnu-sed
SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"

if [ -z $1 ] ; then
	echo -e "${RED}APP NAME not given";
	exit 1;
fi

if [ -f $APP_NAME ] ; then
	echo -e "${RED}APP folder not found";
	exit 1;
fi

#Create file for checking messaging 
CONFIG="$PWD/$APP_NAME.py"

#CHECK THE UPDOWN FILE EXIST
if [[ ! -e $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/djangosettings.stub" $CONFIG
$SED -i "s/{{APP_NAME}}/$APP_NAME/g" $CONFIG
mv $CONFIG "$APP_NAME/$APP_NAME/settings.py"
sudo chmod 644 "$APP_NAME/$APP_NAME/settings.py"

