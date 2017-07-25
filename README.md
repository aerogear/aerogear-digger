# digger-jenkins
Digger on Jenkins: An OpenSource Build Farm for mobile app builds in the cloud

Give us mobile app source code and we would build it for you!

![](http://i.imgur.com/XmDnbeo.jpg)

## Purpose of the project

Provide complete mobile build solution on top of Jenkins and OpenShift platforms.

## How to use it

Digger would allow you to build your mobile apps (and any other apps) using instruction provided in `Jenkinsfile` located in your code.
To create digger jenkins use openshift template provided in this repository and download one of the clients to interact with the server.
You can also login directly to jenkins ui and customize it for your own needs.

## Clients

Use one of the clients bellow to interact with the digger jenkins api.

- Node.js command line client and library:
https://github.com/aerogear/digger-node

- Java library: https://github.com/aerogear/digger-java

## Repo structure

Please check individual folders for more information

### `/docker` folder
Contains custom Jenkins Dockerfiles.

[See the readme](../master/docker)

### `/jenkinsfiles`
Contains Jenkins job definitions for each platform

[See the readme](../master/jenkinsfiles)

### `/admin`
Contains Jenkins groovy scripts used to perform administration tasks on jenkins

[See the readme](../master/admin)

## Installation

AeroGear Digger can be installed using Ansible Scripts available in the github repo [digger-installer](https://github.com/aerogear/digger-installer)


## Using AeroGear Digger

In order to build your mobile application with AeroGear Digger, you have to have a Jenkinsfile in your mobile app's source tree.

A [Jenkinsfile](https://jenkins.io/doc/book/pipeline/jenkinsfile/) is a Groovy file that is used by Jenkins that runs at AeroGear Digger's heart.

While you can use any feature provided with Jenkinsfile you like, there are some key things that are important.

There are some sample Jenkinsfiles provided by AeroGear Digger project in [here](jenkinsfiles/).

##### Place the Jenkinsfile

Jenkinsfile should be put directly on the root of the source tree. You should use file name `Jenkinsfile` with no extension. 

##### Use the correct "node"

In ideal usage, AeroGear Digger uses Jenkins agents (AKA slaves) to build mobile applications. Different agents are configured for mobile platforms
and you have to use `node` statements to use the correct nodes.

```groovy
    node("android"){
      stage("Build"){
        // ...
        sh './gradlew clean assembleDebug'
        // ...
      }
      // ...
    }
```

The build above will be executed in an agent that is prepared to build Android applications.

The node given should match the *node label* configuration in Jenkins. If you are using 
[digger-installer](https://github.com/aerogear/digger-installer) Ansible role to deploy AeroGear Digger,
the default node labels will be `android` and `ios`.

### Anatomy of a Jenkinsfile

```groovy
    /**
    * Android Jenkinsfile
    */
1   node("android"){
2     stage("Checkout"){
3       checkout scm
      }
    
      stage ("Prepare"){
4       writeFile file: 'app/src/main/assets/fhconfig.properties', text: params.FH_CONFIG_CONTENT
      }
    
5     stage("Build"){
        sh 'chmod +x ./gradlew'
        if (params.BUILD_CONFIG == 'release') {
          sh './gradlew clean assembleRelease' // builds app/build/outputs/apk/app-release.apk file
        } else {
          sh './gradlew clean assembleDebug' // builds app/build/outputs/apk/app-debug.apk
        }
      }
    
6     stage("Sign"){
        if (params.BUILD_CONFIG == 'release') {
            signAndroidApks (
                keyStoreId: "${params.BUILD_CREDENTIAL_ID}",
                keyAlias: "${params.BUILD_CREDENTIAL_ALIAS}",
                apksToSign: "**/*-unsigned.apk",
                // uncomment the following line to output the signed APK to a separate directory as described above
                // signedApkMapping: [ $class: UnsignedApkBuilderDirMapping ],
                // uncomment the following line to output the signed APK as a sibling of the unsigned APK, as described above, or just omit signedApkMapping
                // you can override these within the script if necessary
                // androidHome: '/usr/local/Cellar/android-sdk'
            )
        } else {
          println('Debug Build - Using default developer signing key')
        }
      }
    
7    stage("Archive"){
        if (params.BUILD_CONFIG == 'release') {
            archiveArtifacts artifacts: 'app/build/outputs/apk/app-release.apk', excludes: 'app/build/outputs/apk/*-unaligned.apk'
        } else {
            archiveArtifacts artifacts: 'app/build/outputs/apk/app-debug.apk', excludes: 'app/build/outputs/apk/*-unaligned.apk'
        }
      }
    }
```

1. Tell AeroGear Digger to execute the build in an Android building node
2. Define a new stage. This is done to visualize the pipeline in Jenkins in a nice way.
3. Check out the source code. As Jenkins build already knows the SCM, this step is doing a very generic way
   of checking out the source code independently from the type of SCM.
4. This is an optional step to create a file to be put in the application archive. If you have any configuration
   that is to be fed to mobile app within a CI/CD pipeline, this is how you can do it. Jenkins build must be 
   parametrized and it should have a parameter named `FH_CONFIG_CONTENT`.
5. Gradle is executed to run the build here. Similar to step #4 above, `BUILD_CONFIG` is a Jenkins build
   parameter and it defines what kind of build to execute (release/debug/etc.)
6. Use Jenkins [Android Signing Plugin](https://wiki.jenkins.io/display/JENKINS/Android+Signing+Plugin) to sign
   the binary. Parameters passed to that plugin can be seen [here](https://wiki.jenkins.io/display/JENKINS/Android+Signing+Plugin).
7. Archive the built and signed binary so that it is easily accessible in Jenkins. You can use 
   [Digger Java Client](https://github.com/aerogear/digger-java) or [Digger Node Client](https://github.com/aerogear/digger-node)
   to access and download archived artifacts.
    