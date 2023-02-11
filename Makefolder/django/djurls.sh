#!/bin/bash
#usage START_APP_NAME
APP_NAME=$1
START_APP_NAME=$2
DEFF_MAKER=${3:-"Makefolder/django"}
RED='\033[0;31m'
#LINUX
# SED=$(which sed)
#MACOS, brew install gnu-sed
# SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
case "$OSTYPE" in
  darwin*)  SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" ;; 
#   darwin*)  SED="/usr/local/bin/gsed" ;; 
  linux*)   SED=$(which sed) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac

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

#Create file for urls
CONFIG="$PWD/$DEFF_MAKER/$START_APP_NAME.startapp.py"

#CHECK THE UPDOWN FILE EXIST
if [[ ! -e $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/$DEFF_MAKER/djangoappurls.stub" $CONFIG
$SED -i "s/{{START_APP_NAME}}/$START_APP_NAME/g" $CONFIG
mv $CONFIG "$APP_NAME/$APP_NAME/urls.py"
sudo chmod 644 "$APP_NAME/$APP_NAME/urls.py"
cp $DEFF_MAKER/djangourls.stub "$APP_NAME/$START_APP_NAME/urls.py"
sudo chmod 644 "$APP_NAME/$START_APP_NAME/urls.py"
cp $DEFF_MAKER/djangoview.stub "$APP_NAME/$START_APP_NAME/views.py"
sudo chmod 644 "$APP_NAME/$START_APP_NAME/views.py"