# Aerogear Jenkins openshift docker image

## Why another image?

OpenShift Jenkins docker images use `source to image` aproach for customizing jenkins plugins and configuration.
We make use of the 'source to image' so that any changes made to the jenkins configuration and plugins would be persisted

For base image source code and documentation please refer to https://github.com/openshift/jenkins

## Building

To build install s2i build tool from: https://github.com/openshift/source-to-image/releases/tag/v1.1.3 

    s2i build . openshift/jenkins-1-centos7 aerogear/jenkins-1-centos7

## Versions

To use different os or jenkins version please use different base image.
Available images here: https://github.com/openshift/jenkins

## Development

Sample development workflow

1. Apply changes in the jenkins instance

Change jenkins confinguration and pipelines definitions as you wish.


2. Update repository

If changing jenkins pipeline definition update coresponding jenkinsfile in repository.
For internal jenkins configuration we would need to extract it and update it manually.

3. Extracting jenkins configuration

    oc project {jenkins project}
    oc rsh {jenkins-pod}
    cat /var/lib/jenkins/configuration.xml

Copy configuration into the repository and build new image.

## Jenkins Slaves docker files

Jenkins kubernetes plugin slaves:

-  [android-slave](./android-slave)

