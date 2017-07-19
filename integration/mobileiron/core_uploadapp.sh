#!/bin/bash

# This script will upload the given binary to MobileIron Cloud
usage() 
{
  echo "Usage: core_uploadapp.sh <MobileIron host> <MobileIron username> <MobileIron password> <path to the file to upload>"
}

if [ "$#" -ne 4 ]; then
  usage
  exit 1
fi

HOST=$1
USERNAME=$2
PASSWORD=$3
FILE_TO_UPLOAD=$4

curl -k -sS -u $USERNAME:$PASSWORD -X POST  -H "Content-Type: multipart/form-data" -F "installer=@$FILE_TO_UPLOAD" https://$HOST/rest/api/v2/appstore/inhouse?adminDeviceSpaceId=1
echo "\nDone"