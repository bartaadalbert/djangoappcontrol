#!/bin/bash
RED='\033[0;31m'
DEFF_MAKER=${6:-"Makefolder/docker"}
#LINUX
# SED=$(which sed)
#MACOS, brew install gnu-sed
# SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
case "$OSTYPE" in
  darwin*)  SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" ;;
  linux*)   SED=$(which sed) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac
APP_IMAGE_NAME=${1:-"app"}
DB_IMAGE_NAME=${2:-'db'}
REDIS_IMAGE_NAME=${3:-'redis'}
NGINX_IMAGE_NAME=${4:-'nginx'}
COMPOSE_NAME=${5:-"app_docker_compose.stub"}


if [[ "$1" != "" ]] && [[ "$2" != "" ]] && [[ "$3" != "" ]] && [[ "$4" != "" ]]; then
    echo "Changing docker compose service names ..."
else
    echo -e "${RED}invalid inputs"
     exit 1
fi

#Create file for checking messaging 
CONFIG="$PWD/$DEFF_MAKER/$APP_IMAGE_NAME.compose"

# echo $CONFIG
# echo $DEFF_MAKER
# exit 1

#CHECK THE UPDOWN FILE EXIST
if [[ ! -f $CONFIG ]]; then
    touch $CONFIG
    sleep 1
fi

cp "$PWD/$DEFF_MAKER/$COMPOSE_NAME" $CONFIG
$SED -i "s/{{APP_IMAGE_NAME}}/$APP_IMAGE_NAME/g" $CONFIG
$SED -i "s/{{DB_IMAGE_NAME}}/$DB_IMAGE_NAME/g" $CONFIG
$SED -i "s/{{REDIS_IMAGE_NAME}}/$REDIS_IMAGE_NAME/g" $CONFIG
$SED -i "s/{{NGINX_IMAGE_NAME}}/$NGINX_IMAGE_NAME/g" $CONFIG



