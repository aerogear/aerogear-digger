#!/usr/bin/env bash

if [ ! -z "${KUBERNETES_CONFIG}" ]; then
    echo "Generating kubernetes-plugin credentials into (${JENKINS_HOME}/credentials.xml) ..."
    export KUBERNETES_CREDENTIALS=$(generate_kubernetes_credentials)
fi

if [ ! -z "${OSX_SLAVE_HOST}" ]; then
    echo "Generating OSX slave credentials into (${JENKINS_HOME}/credentials.xml) ..."
    export OSX_SLAVE_CREDENTIALS=$(generate_kubernetes_credentials)
else
    echo "Skipping generating OSX slave credentials since \${OSX_SLAVE_HOST} is not specified ..."
fi


# Fix the envsubst trying to substitute the $Hash inside credentials.xml
export Hash="\$Hash"
envsubst < "${image_config_dir}/credentials.xml.tpl" > "${image_config_dir}/credentials.xml"
