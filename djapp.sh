#LINUX
SED=$(which sed)
#MACOS, brew install gnu-sed
SED="/usr/local/opt/gnu-sed/libexec/gnubin/sed"
#set $SETTINGS_FILE variable to full path of the your django project settings.py file
SETTINGS_FILE=$1"/$1/settings.py"
# checks that app $2 is in the django project settings file
is_app_in_django_settings() {
    # checking that django project settings file exists
    if [ ! -f $SETTINGS_FILE ]; then
        echo "Error: The django project settings file $SETTINGS_FILE does not exist"
        exit 1
    fi
    cat $SETTINGS_FILE | grep -Pzo "INSTALLED_APPS\s?=\s?\[[\s\w\.,']*$2[\s\w\.,']*\]\n?" > /dev/null 2>&1
    # now $?=0 if app is in settings file
    # $? not 0 otherwise
}

# adds app $2 to the django project settings
add_app2django_settings() {
    is_app_in_django_settings $2
    if [ $? -ne 0 ]; then
        echo "Info. The app $2 is not in the django project settings file $SETTINGS_FILE. Adding..."
        $SED -i -e '1h;2,$H;$!d;g' -re "s/(INSTALLED_APPS\s?=\s?\[[\n '._a-zA-Z,]*)/\1    '$2',\n/g" $SETTINGS_FILE
        # checking that app $2 successfully added to django project settings file
        is_app_in_django_settings $2
        if [ $? -ne 0 ]; then
            # echo "Error. Could not add the app '$2' to the django project settings file '$SETTINGS_FILE'. Add it manually, then run this script again."
            echo "Info. The app '$2' was successfully added to the django settings file '$SETTINGS_FILE'."
            exit 0
        else
            echo "Info. The app '$2' was successfully added to the django settings file '$SETTINGS_FILE'."
        fi
    else
        echo "Info. The app '$2' is already in the django project settings file '$SETTINGS_FILE'"
    fi
}

add_app2django_settings $1 $2