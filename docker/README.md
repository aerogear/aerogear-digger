# Aerogear Jenkins openshift docker image

## Why another image?

OpenShift Jenkins docker images use `source to image` aproach for customizing jenkins plugins and configuration. 
We need to use it in order to make any change in jenkins configuration that would be persisted in image.

For base image source code and documentation please refer to https://github.com/openshift/jenkins

## Building

To build install s2i build tool from: https://github.com/openshift/source-to-image/releases/tag/v1.1.3 

    s2i build . openshift/jenkins-1-centos7 aerogear/jenkins-1-centos7