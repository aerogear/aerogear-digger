## Uploading Client App binaries built with Aerogear Digger to MobileIron MDM repositories

Include these scripts in your Jenkins pipeline to automatically upload Client App binaries to MobileIron.

## Prerequisities
If using macOS, have `grep` installed.

## Upload Client App binaries to MobileIron Cloud

Use `cloud_uploadapp.sh` to upload apps to MobileIron Cloud.

To use this script as part of a Jenkins pipeline, include it in the Client App repo, and modify the App building Jenkinsfile to invoke the script after the build by adding the following code:

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

## Upload Client App binaries to MobileIron Core

Use `core_uploadapp.sh` to upload apps to MobileIron Core. The API for uploading apps is different from  MobileIron Cloud.

To use this script as part of a Jenkins pipeline, include it in the Client App repo, and modify the App building Jenkinsfile to invoke the script after the build by adding the following code:

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

