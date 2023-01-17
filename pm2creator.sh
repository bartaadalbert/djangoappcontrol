#!/bin/bash
RED='\033[0;31m'
#LINUX
SED=$(which sed)
#MACOS, brew install gnu-sed
SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
APP_NAME=${1:-"my_app"}
FINAL_PORT=${2:-8080}

#CHECK THE UPDOWN FILE EXIST
if [[ ! -d $APP_NAME ]]; then
    echo -e "${RED}Your app was not configured"
    exit 1
fi

#Create file for checking messaging 
CONFIG="$PWD/$APP_NAME.config.js"

#CHECK THE UPDOWN FILE EXIST
if [[ ! -e $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/pm2.stub" $CONFIG
$SED -i "s/{{APP_NAME}}/$APP_NAME/g" $CONFIG
$SED -i "s/{{FINAL_PORT}}/$FINAL_PORT/g" $CONFIG


