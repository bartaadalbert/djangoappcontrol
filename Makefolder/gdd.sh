#!/bin/bash
#usage domain/subdomain_name/ PUT default cen USE DELETE
RED='\033[0;31m'
YELLOW='\033[1;33m' 
DOMAIN=$1
SUB_DOMAIN=$2
GODADDY_API_KEY=GODADDY_API_KEY
GODADDY_API_SECRET=GODADDY_API_SECRET
CURL_EXTION=${3:-"PUT"}
# Get IP Address
# DEF_IP=`dig $DOMAIN +short @resolver1.opendns.com`

IP=${4:-`dig $DOMAIN +short @resolver1.opendns.com`}
echo $IP
exit 1
if [ -z $1 ] || [ -z $2 ]; then
	echo -e "${RED}Domain or subdomain not given";
	exit 1;
fi

if [ $CURL_EXTION == "PUT" ] || [ $CURL_EXTION == "DELETE" ]; then 
	
	# Create DNS A Record
	curl -X $CURL_EXTION \
	-H 'Content-Type: application/json' \
	-H 'Accept: application/json' \ 
	-H "Authorization: sso-key $GODADDY_API_KEY:$GODADDY_API_SECRET" \
	"https://api.godaddy.com/v1/domains/$DOMAIN/records/A/$SUB_DOMAIN" \
	-d "[{\"data\": \"$IP\", \"ttl\":600}]"
else
	echo -e "${YELLOW}YOU can use PUT or DELETE in CURL query, default PUT"
	exit 1;
fi

