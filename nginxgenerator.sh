#!/bin/bash
RED='\033[0;31m'
#LINUX
SED=$(which sed)
#MACOS, brew install gnu-sed
SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
PROXYPASS=${2:-"http://127.0.0.1:8008"}
LISTEN=${3:-80}

# check the domain is valid!
PATTERN="^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$"
if [[ "$1" =~ $PATTERN ]]; then
  SERVERNAME=$(echo $1 | tr '[A-Z]' '[a-z]')
  echo "Creating hosting for:" $SERVERNAME
else
  echo -e "${RED}invalid domain name"
  exit 1
fi

#Create file for checking messaging 
CONFIG="$PWD/$SERVERNAME.conf"

#CHECK THE UPDOWN FILE EXIST
if [[ ! -e $CONFIG ]]; then
    touch $CONFIG
fi

cp "$PWD/subdomain.stub" $CONFIG
$SED -i "s/{{SERVERNAME}}/$SERVERNAME/g" $CONFIG
$SED -i "s/{{PROXYPASS}}/$PROXYPASS/g" $CONFIG
$SED -i "s/{{LISTEN}}/$LISTEN/g" $CONFIG


