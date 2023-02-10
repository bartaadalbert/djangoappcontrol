#!/bin/bash
#usage APP NAME POST default, can USE DELETE
RED='\033[0;31m'
YELLOW='\033[1;33m' 
APP_NAME=$1
OWNER=bartaadalbert
GIT_ACCESS_TOKEN=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
CURL_EXTION=${2:-"POST"}

if [ -z $1 ] ; then
	echo -e "${RED}APP NAME not given";
	exit 1;
fi

#USING DELETE CHECK TOKEN ACCESS!!!!!! 
URL=https://api.github.com/user/repos
if [ $CURL_EXTION == "DELETE" ]; then
	URL=https://api.github.com/repos/$OWNER/$APP_NAME
fi

if [ $CURL_EXTION == "POST" ] || [ $CURL_EXTION == "DELETE" ]; then 
	# Create REPO IN GITHUB
	curl -X $CURL_EXTION \
	-H 'Accept: application/vnd.github+json' \
	-H "Authorization: Bearer $GIT_ACCESS_TOKEN" \
	-H "X-GitHub-Api-Version: 2022-11-28" \
	$URL \
	-d "{\"name\":\"$APP_NAME\",\"homepage\":\"https://github.com\",\"private\":true,\"is_template\":false}" \
	| jq -r '.errors [].message'
	exit 0
else
	echo -e "${YELLOW}YOU can use POST or DELETE in CURL query, default POST"
	exit 1;
fi


