#!/bin/bash

# Use this script to upload the Client App binaries to MobileIron Cloud
usage() 
{
  echo "Usage: cloud_uploadapp.sh <MobileIron host> <MobileIron username> <MobileIron password> <platform name (IOS or Android)> <path to the file to upload>"
}

if [ "$#" -ne 5 ]; then
  usage
  exit 1
fi

HOST=$1
USERNAME=$2
PASSWORD=$3
PLATFORM=$4
FILE_TO_UPLOAD=$5

GREP_CLI="grep"
if [ "$(uname)" == "Darwin" ]; then
  GREP_CLI="ggrep"
fi

PARTITION_ID=`curl -s -u $USERNAME:$PASSWORD -X GET https://$HOST/api/v1/account?metadata | $GREP_CLI -Po '"defaultCmPartitionId":\K(\d*?)(?=,)'`
echo "PARTITION_ID = $PARTITION_ID"

curl -u $USERNAME:$PASSWORD -X POST  -H "Content-Type: multipart/form-data" -F "app-data=@$FILE_TO_UPLOAD" -F "cmPartitionId=$PARTITION_ID" -F "platformType=$PLATFORM" https://$HOST/api/v1/app
echo "\nDone"
