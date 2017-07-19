## Introduction

The scripts here are used to upload built binaries to MobileIron automatically. They can be included in the Jenkins pipeline as part of CI/CD process.

## Upload to MobileIron Cloud

The `cloud_uploadapp.sh` is used to upload apps to MobileIron Cloud.

To use this script as part of the Jenkins pipeline, you should include this file in your repo, and then add a stage after the app is built in the Jenkinsfile to invoke the script like this:

```groovy
stage("Upload To MobileIron Cloud"){
  def host = '<your MobileIron Cloud host here>'
  def username = '<your MobileIron Cloud username here>'
  def password = '<your MobileIron Cloud password here>'
  //only required if the file is not executable
  sh (
    script: "chmod +x ./cloud_uploadapp.sh"
  )
  sh (
    //sample for upload for an Android app
    script: "./cloud_uploadapp.sh ${host} ${username} ${password} ANDROID ./app/build/outputs/apk/app-debug.apk"

    //it will be like this for uploading an iOS app
    //script: "./uploadapp.sh ${host} ${username} ${password} IOS ./helloworld-ios/build/Debug-iphoneos/myapp.ipa"
  )
 }
```

## Upload to MobileIron Core

The `core_uploadapp.sh` can be used to upload apps to MobileIron Core. The API for uploading apps is different in MobileIron Core.

Similarly, you can use the following code to upload an app to MobileIron Core after it's built:

```groovy
stage("Upload To MobileIron Core") {
  def host = '<your MobileIron Core host here>'
  def username = '<your MobileIron Core username here>'
  def password = '<your MobileIron Core password here>'
  //only required if the file is not executable
  sh (
    script: "chmod +x ./core_uploadapp.sh"
  )
  sh (
    //sample for upload for an Android app
    script: "./core_uploadapp.sh ${host} ${username} '${password}' ./app/build/outputs/apk/app-debug.apk"

    //it will be like this for uploading an iOS app
    //script: "./core_uploadapp.sh ${host} ${username} '${password}' ./helloworld-ios/build/Debug-iphoneos/myapp.ipa"
  )
 }
 ```

