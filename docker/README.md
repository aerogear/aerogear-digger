# AeroGear Digger Docker images

This directory contains the Docker source for images that are used in AeroGear Digger.

We use the [Jenkins image](https://github.com/openshift/jenkins) from OpenShift team as the Jenkins master.

However, we use custom images for slaves.

## android-slave

This is the Jenkins Android slave that is used to build Android applications.

It has the base tools required to build an Android application. The Android SDK however, is not included.

## android-sdk

This is an image that is preconfigured to download Android SDK. Android SDK cannot be included in the container directly because of the license issues.
                                   
Thus, this image contains a "androidctl" script which installs the Android sdk and its related packages that prompts you to accept the license. 
However, keep in mind that it does not automate the "accept license" step (you need to manually accept the android/google license/terms and conditions).

The Android SDK in the container will be reused by the Android slave containers.



## Building

Both Android slave and Android SDK images can be built and published using the usual Docker commands. 

    cd android-slave
    docker build . -t aerogear/jenkins-android-slave
    
    cd android-sdk
    docker build . -t aerogear/android-sdk    

For release builds, publish image to Docker Hub:

    docker push aerogear/jenkins-android-slave
    docker push aerogear/android-sdk