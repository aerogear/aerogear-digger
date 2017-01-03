#!/bin/sh

if [ ! -z "${OSX_SLAVE_HOST}" ]; then
    echo "Copying Jenkins OSX node configuration to ${JENKINS_HOME}/nodes ..."
    mkdir -p ${image_config_dir}
    cp -r ${image_config_dir}/nodes ${JENKINS_HOME}/nodes
    rm -rf ${image_config_dir}/nodes

    envsubst < "${JENKINS_HOME}/nodes/digger-ios/config.xml.tpl" > "${JENKINS_HOME}/nodes/digger-ios/config.xml"
else
    echo "Skipping copying OSX node configuration since \${OSX_SLAVE_HOST} is not specified ..."
fi
