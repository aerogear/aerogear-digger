# AeroGear Digger Jenkins OpenShift Docker images

This directory contains the Docker source for Jenkins master and slaves for AeroGear Digger.

Please note that the images published to Docker Hub: <https://hub.docker.com/r/aerogear/>

From a user's point of view, you don't need to do anything here in order to build apps using AeroGear Digger.

Unless you need to change the Jenkins Docker images, you don't need to do any of the things required here.


## AeroGear Digger Jenkins Master OpenShift Docker image

This is the source for image in Docker Hub: <https://hub.docker.com/r/aerogear/jenkins-1-centos7/>

Unless you need to change the Jenkins Docker image, you don't need to do any of the things required here.

From a user's point of view, you don't need to do anything here in order to build apps using AeroGear Digger.


### Why another image?

OpenShift Jenkins Docker images use "source to image" approach for customizing Jenkins plugins and configuration.
We make use of the "source to image" so that any changes made to the Jenkins configuration and plugins would be persisted.

For base image source code and documentation please refer to <https://github.com/openshift/jenkins>.

### Building

S2I build is required in order to install new plugins and configuration.

Install `s2i` build tool from: <https://github.com/openshift/source-to-image/releases/tag/v1.1.3>
Execute the build command:

    s2i build . openshift/jenkins-1-centos7 aerogear/jenkins-1-centos7

For release builds, publish image to Docker Hub:

    docker push aerogear/jenkins-1-centos7

### Versions

To use different OS or Jenkins versions please use different base images when executing `s2i build`.

Available images are here: <https://github.com/openshift/jenkins>.

### Development

Sample development workflow

1. Apply changes in the Jenkins instance

Change Jenkins configuration and pipelines definitions as you wish.


2. Update repository

If you would like to change Jenkins pipeline definition, update corresponding `jenkinsfile` in repository.

For internal Jenkins configuration we would need to make changes on a Jenkins instance using the UI,
then extract the configuration and update it manually.

3. Extracting Jenkins configuration

```
    oc project {jenkins project}
    oc rsh {jenkins-pod}
    cat /var/lib/jenkins/configuration.xml
```

Then, copy configuration into the repository and build new image.

## Jenkins Slaves `Dockerfile`s

Jenkins Kubernetes plugin slaves:

-  [android-slave](./android-slave)

