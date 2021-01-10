#!/bin/bash

# Uploads activities to runalyze REST-API
#
# usage:
# ./runalyzeUpload.sh user ./../X localhost:8022
# ./runalyzeUpload.sh user /run/user/$UID/gvfs/mtp*/Primary/GARMIN/Activity localhost:8022

set -e

# input parameters
USER=$1
IMP_FOLDER=$2
RUNALYZE_DOMAIN=$3

# runalyze url
RUNALYZE_URL=https://${RUNALYZE_DOMAIN}/api/import/activity

# 1=erweiterte Debug-Ausgabe
DEBUG=0

# validate the input
if [ -z $USER ]; then
	echo "Parameter 1=USER must be set!"
	exit 1
fi
if [ -z $IMP_FOLDER ]; then
	echo "Parameter 2=IMP_FOLDER must be set!"
	exit 1
fi
if [ -z $RUNALYZE_DOMAIN ]; then
	echo "Parameter 3=RUNALYZE_DOMAIN must be set!"
	exit 1
fi

# retrieve the files
files=`find $IMP_FOLDER -maxdepth 1 -type f`

# info what to do
echo "Import `echo -e "$files" | wc -l` files from >${IMP_FOLDER}< to >${RUNALYZE_DOMAIN}< user >$USER<"

# build the curl "form" parameter-list
curlForm=''
i=0
for line in $files; do
	i=$((i+1))
	curlForm="$curlForm -F 'file$i=@$line'"
done

# build the command
# use a file 3 for "forward" the output of curl to file 3 / stdout
exec 3>&1 
cmd="curl -k -u '${USER}' -H 'Accept-Language: de,en' -s -w '%{http_code}' -o >(cat >&3) -X POST $RUNALYZE_URL $curlForm"

if [ $DEBUG == "1" ]; then
	echo "Execute cmd: $cmd"
fi

# process build command
httpStatus=$(eval "$cmd")
echo "HTTP-Code is ${httpStatus}"

# exit code based on the http-status code of the curl command
if [ $httpStatus == "200" ]; then
	exit 0
elif [ $httpStatus == "202" ]; then
	exit 1
else
	exit 2
fi

