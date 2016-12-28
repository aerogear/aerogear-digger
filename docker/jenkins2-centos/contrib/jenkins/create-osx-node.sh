#!/bin/sh

echo "Copying Jenkins node configurations to ${JENKINS_HOME}/nodes ..."
mkdir -p ${image_config_dir}
cp -r ${image_config_dir}/nodes ${JENKINS_HOME}/nodes
rm -rf ${image_config_dir}/nodes

envsubst < "${JENKINS_HOME}/nodes/digger-ios/config.xml.tpl" > "${JENKINS_HOME}/nodes/digger-ios/config.xml"
