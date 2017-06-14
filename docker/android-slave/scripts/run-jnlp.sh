#!/bin/bash

check_params=$(echo "$1 $2" | grep -o "cordova\|node\|npm\|java")

if [[ "$check_params" == "cordova" ]] ||  [[ "$check_params" == "java" ]] || [[ "$check_params" == "node" ]] || [[ "$check_params" == "npm" ]] 
then
  exec "$@"
else
  # execute the original entry point with parameters
  /usr/local/bin/run-jnlp-client "$@"
fi
