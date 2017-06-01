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

    cd jenkins2-centos
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
    cat /var/lib/jenkins/config.xml
```

Then, copy configuration into the repository ([`configuration.xml.tpl`](./configuration/configuration.xml.tpl)) and build new image.


## Jenkins Slaves `Dockerfile`s

Jenkins Kubernetes plugin slaves:

-  [android-slave](./android-slave)

### Build

The android slave extends the openshift/jenkins-slave-base-centos7

    cd android-slave directory
    docker build -t docker.io/aerogear/jenkins-android-slave:2.0.0 

If changes were made then execute the following

    docker push docker.io/aerogear/jenkins-android-slave:2.0.0

The android-sdk will be installed and mounted on a PV (persistent volume in OpenShift) refer to [android-sdk](./android-sdk) 

For configuration of this image :-

- Navigate to the Jenkins web console
- Click on the link Manage Jenkins
- Click on the link item 'Configure System'
- Navigate to the section 'Kubernetes Pod Template'
- Click on Add Pod Template
- Enter 'android' for the pod name
- Eneter 'android for the pod label
- Click on 'Add' (container section)
- For the container name enter 'jnlp'
- Enter 'aerogear/jenkins-android-slave:2.0.0' for the docker image
- Enter '/opt/android-sdk-linux' for the working directory (this is important - do not change it to anything else)
- Enter '${computer.jnlpmac} ${computer.name}' for the arguments to pass
- Now click on the section 'Add Environment Variable'
- Enter 'ANDROID_HOME' for the key
- Enter '/opt/android-sdk-linux'
- Click on the section 'Add Volume' and select 'Persistent Volumke Claim'
- Enter 'android-sdk' for the claim name (important do not change it to anything else)
- Click 'Read Only' (i.e ensure it is enabled)
- Enter '/opt/android-sdk-linux' for the mount path
- Save (we are all done !!!)



For release builds, publish the image to the openshift internal registry - please refer to this link for more info
https://docs.openshift.com/container-platform/3.3/dev_guide/managing_images.html
