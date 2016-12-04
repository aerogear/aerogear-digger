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

### Build

We are using s2i technology to for building mobile jenkins slaves. During the s2i build, a specific version of the Android SDK is installed and the user is asked to confirm all required licenses.

The android slave extends the openshift/jenkins-slave-base-centos7
Any change in s2i dockerfile would require an image build.

    cd android-slave directory
    docker build -t aerogear/jenkins-android-slave-s2i

If no changes are needed, pull the base s2i image from docker

```
docker pull docker.io/aerogear/android-sdk-sti

```

To include the android-sdk, download the required sdk, install and accept the license agreement
The following script is an example of downloading the sdk installation

    ```
    wget --output-document=android-sdk.tgz --quiet https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
    tar xzf android-sdk.tgz 
    
    android-sdk-linux/tools/android update sdk --all --no-ui --filter platform-tools,tools,build-tools-25.0.0,android-25,addon-google_apis_x86-google-21,extra-android-support,extra-google-google_play_services

    ```
Now execute the s2i build, assuming we are using the base image (docker.io/aerogear/android-sdk-sti i.e. no changes were needed)
This will build the final image with the android sdk version that was installed

    ```
    s2i build <directory-where-sdk-has-been-installed> docker.io/aerogear/android-sdk-sti aerogear/jenkins-android-slave:<version>
    
    ```

For release builds, publish the image to the openshift internal registry - please refer to this link for more info
https://docs.openshift.com/container-platform/3.3/dev_guide/managing_images.html
