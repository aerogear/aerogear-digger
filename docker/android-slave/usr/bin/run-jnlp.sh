#!/bin/bash

if [ "$#" -gt 2 ]
then
  # execute the original entry point with parameters
  /usr/local/bin/run-jnlp-client "$@"
fi

exec "$@"
