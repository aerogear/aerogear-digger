# AeroGear Digger
An OpenSource Build Farm for building mobile app builds in the cloud

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

- Java client: https://github.com/aerogear/aerogear-digger-java-client

## Kick start

Check out the video [here](https://youtu.be/DxPgJcD6KSY) to kick start AeroGear Digger!
Here are the instructions used in that video:

#### Requirements

* Docker
* OpenShift
* Ansible 2.2.2+

#### Start OpenShift

We use `oc cluster up` to start an OpenShift cluster for our kick start. Just download OpenShift CLI, `oc`, 
from [this page](https://github.com/openshift/origin/releases) if you don't have it already.

Using version 3.6.0 and up is recommended as `oc cluster up` command in those newer versions creates some predefined 
persistent volumes. 

```
oc cluster up
```

You can now open <https://127.0.0.1:8443> in your browser to access OpenShift web console. Use "developer/developer" for username/password.

#### Install

Now we clone the installer repository which has an example inventory and a playbook configured to run with `oc cluster up`.

We can then execute the playbook. Please note that during the execution of the playbook, some calls are made to the Jenkins instance that is to be created.
Those calls need authentication and the authentication method that is suitable in our case is "public key infrastructure". This means, you will be prompted
during the execution of the playbook to install your public key to Jenkins.
Jenkins CLI uses `~/.ssh/identity` or `~/.ssh/id_rsa` if the first one doesn't exist.

Currently, it is not possible to make the installer to use another keypair. This will be possible with <https://issues.jboss.org/browse/AGDIGGER-230>.

```
# clone the installer
git clone https://github.com/aerogear/digger-installer.git

# go into it
cd digger-installer

# run the installer playbook 
# we skip the OSX part, for the sake of kick-starting
ansible-playbook -i cluster-up-example sample-build-playbook.yml -e skip_tls=true -e jenkins_route_protocol=http --skip-tags "provision-osx -e jenkins_private_key_password=<PRIVATE_KEY_PASSWORD>"
``` 

You can now open <http://jenkins-digger.127.0.0.1.nip.io> in your browser to access Jenkins UI. Use "admin/password" for username/password.

#### Build

We are going to use a sample application hosted at <https://github.com/aliok/android25sampleapp> to test building an application.
It is a very simple blank application that has a simplified `Jenkinsfile` for the sake of simplicity of the kick-start. 

```
# install Digger CLI
npm install digkins -g

# login to Digger with the CLI
digkins login http://jenkins-digger.127.0.0.1.nip.io --user=admin --password=password

# create a job, named "sample"
digkins job create sample https://github.com/aliok/android25sampleapp.git master

# trigger a build, get a build number
digkins job build sample

# watch the logs for the build
# build number will be 1, as it is the first build
digkins log sample 1

# wait until the build is finished successfully.
# get the artifact url. (artifact here is the Android binary, *.apk file) 
digkins artifact sample 1

# download the binary
wget --auth-no-challenge --http-user=admin --http-password=password 
http://jenkins-digger.127.0.0.1.nip.io/job/sample/1/artifact/app/build/outputs/apk/app-debug.apk 
```

#### Install built binary on Device

If you would like to install the binary on an emulator, create a new AVD first.
In the demo video, we created a new AVD named "Nexus_5X_API_25" manually in Android Studio.

If you would like to install the binary on your device, just plug in your device.

```
# start the emulator, if you would like to install on an emulator
# for some reason, one must cd into the emulator folder. otherwise it emulator won't start.
cd $ANDROID_SDK_ROOT/emulator
emulator -avd Nexus_5X_API_25
```

```
# install on emulator or device
adb install app-debug.apk
```

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
    