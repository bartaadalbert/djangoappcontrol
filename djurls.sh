#!/bin/bash
#usage START_APP_NAME
APP_NAME=$1
START_APP_NAME=$2
RED='\033[0;31m'
#LINUX
SED=$(which sed)
#MACOS, brew install gnu-sed
SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"

if [ -z $1 ] ; then
	echo -e "${RED}START APP NAME not given";
	exit 1;
fi

if [ -f $APP_NAME ] ; then
	echo -e "${RED}APP folder not found";
	exit 1;
fi

if [ -f $START_APP_NAME ] ; then
	echo -e "${RED}START APP folder not found";
	exit 1;
fi

#Create file for checking messaging 
CONFIG="$PWD/$START_APP_NAME.startapp.py"

#CHECK THE UPDOWN FILE EXIST
if [[ ! -e $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/djangoappurls.stub" $CONFIG
$SED -i "s/{{START_APP_NAME}}/$START_APP_NAME/g" $CONFIG
mv $CONFIG "$APP_NAME/$APP_NAME/urls.py"
sudo chmod 644 "$APP_NAME/$APP_NAME/urls.py"
cp djangourls.stub "$APP_NAME/$START_APP_NAME/urls.py"
sudo chmod 644 "$APP_NAME/$START_APP_NAME/urls.py"
cp djangoview.stub "$APP_NAME/$START_APP_NAME/views.py"
sudo chmod 644 "$APP_NAME/$START_APP_NAME/views.py"