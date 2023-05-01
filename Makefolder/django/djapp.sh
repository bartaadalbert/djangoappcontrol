#!/bin/bash
#LINUX
# SED=$(which sed)
#MACOS, brew install gnu-sed grep
# SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
#set $SETTINGS_FILE variable to full path of the your django project settings.py file
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

case "$OSTYPE" in
  darwin*)  GREP="/usr/local/bin/ggrep" ;; 
  linux*)   GREP=$(which grep) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac

case "$OSTYPE" in
  darwin*)  SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed" ;; 
  linux*)   SED=$(which sed) ;;
  *)        echo "unknown: $OSTYPE"; exit 1 ;;
esac

SETTINGS_FILE=$2"/$2/settings.py"
# checks that app $1 is in the django project settings file
is_app_in_django_settings() {
    # checking that django project settings file exists
    if [ ! -f $SETTINGS_FILE ]; then
        printf "$RED Error: The django project settings file $SETTINGS_FILE does not exist"
        exit 1
    fi
    cat $SETTINGS_FILE | $GREP -Pzo "INSTALLED_APPS\s?=\s?\[[\s\w\.,']*$1[\s\w\.,']*\]\n?" > /dev/null 2>&1
    # now $?=0 if app is in settings file
    # $? not 0 otherwise
   
}

# adds app $1 to the django project settings
add_app2django_settings() {
    is_app_in_django_settings $1
    if [ $? -ne 0 ]; then
        printf  "Info. The app '$1' is not in the django project settings file '$SETTINGS_FILE'. Adding." >&2;
        $SED -i -e '1h;2,$H;$!d;g' -re "s/(INSTALLED_APPS\s?=\s?\[[\n '._a-zA-Z,]*)/\1    '$1',\n/g" $SETTINGS_FILE
        # checking that app $1 successfully added to django project settings file
        is_app_in_django_settings $1
        if [ $? -ne 0 ]; then
            printf "Error. Could not add the app '$1' to the django project settings file '$SETTINGS_FILE'. Add it manually, then run this script again." >&2;
            exit 1
        else
            printf "Info. The app '$1' was successfully added to the django settings file '$SETTINGS_FILE'." >&2;
            exit 0
        fi
    else
        printf "$YELLOW Info. The app '$1' is already in the django project settings file '$SETTINGS_FILE'"
    fi
}

add_app2django_settings $1 $2