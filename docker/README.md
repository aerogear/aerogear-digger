# Aerogear Jenkins openshift docker image

This directory contains the Docker source for Jenkins master and slaves for AeroGear Digger.

## Why another image?

OpenShift Jenkins Docker images use "source to image" approach for customizing Jenkins plugins and configuration.
We make use of the "source to image" so that any changes made to the Jenkins configuration and plugins would be persisted.

For base image source code and documentation please refer to https://github.com/openshift/jenkins

## Building

S2I build is required in order to install new plugins and configuration
Install s2i build tool from: https://github.com/openshift/source-to-image/releases/tag/v1.1.3
Build openshift jenkins image with our modifications on your local machine

    cd jenkins1-centos
    docker build . -t aerogear/jenkins-2-centos7-s2i

Execute s2i build command:

    s2i build . aerogear/jenkins-2-centos7-s2i aerogear/jenkins-2-centos7

For release builds, publish image to Docker Hub:

    docker push aerogear/jenkins-2-centos7

## Versions

To use different OS or Jenkins versions please use different base images when executing `s2i build`.
Available images here: <https://github.com/openshift/jenkins>

## Development

Sample development workflow

1. Apply changes in the Jenkins instance

Change Jenkins configuration and pipelines definitions as you wish.

2. Update repository

If you would like to change Jenkins pipeline definition, update corresponding `jenkinsfile` in repository.

For internal Jenkins configuration we would need to make changes on a Jenkins instance using the UI,
then extract the configuration and update it manually.

3. Extracting jenkins configuration

```
    oc project {jenkins project}
    oc rsh {jenkins-pod}
    cat /var/lib/jenkins/configuration.xml
```

Then, copy configuration into the repository ([`configuration.xml.tpl`](./configuration/configuration.xml.tpl)) and build new image.


## Jenkins Slaves `Dockerfile`s

Jenkins Kubernetes plugin slaves:

-  [android-slave](./android-slave)

## Build

To build slave execute docker build

    docker build . -t aerogear/jenkins-android-slave

