#!/bin/bash
#usage APP NAME
APP_NAME=$1
SUBDOMAIN=${2:-"http://server.local"}
DEFF_MAKER=${3:-"Makefolder"}
RED='\033[0;31m'
# DJANGO_INSECURE_KEY=$(LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 64 ; echo >&1)
DJANGO_INSECURE_KEY=$(cat /dev/urandom | LC_ALL=C tr -dc 'A-Za-z0-9#$%'\''()*+,-./:?@^_~' | head -c 64)
#LINUX
# SED=$(which sed)
#MACOS, brew install gnu-sed
# SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
case "$OSTYPE" in
  darwin*)  SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" ;; 
  # darwin*)  SED="/usr/local/bin/gsed" ;; 
  linux*)   SED=$(which sed) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac

if [ -z $1 ] ; then
	echo -e "${RED}APP NAME not given";
	exit 1;
fi

if [ -f $APP_NAME ] ; then
	echo -e "${RED}APP folder not found";
	exit 1;
fi

#Create file for checking messaging 
CONFIG="$PWD/$DEFF_MAKER/$APP_NAME.py"

#CHECK THE UPDOWN FILE EXIST
if [[ ! -e $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/$DEFF_MAKER/djangosettings.stub" $CONFIG
$SED -i "s/{{APP_NAME}}/$APP_NAME/g" $CONFIG
$SED -i "s/{{SUBDOMAIN}}/$SUBDOMAIN/g" $CONFIG
$SED -i "s/{{DJANGO_INSECURE_KEY}}/$DJANGO_INSECURE_KEY/g" $CONFIG
mv $CONFIG "$APP_NAME/$APP_NAME/settings.py"
sudo chmod 644 "$APP_NAME/$APP_NAME/settings.py"

