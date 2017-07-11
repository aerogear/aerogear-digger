/**
* Cordova Jenkinsfile
*/

def platform = params?.PLATFORM?.trim()
def buildType = params?.BUILD_CONFIG?.trim()

node(platform) {
    stage("Checkout") {
        checkout scm
    }

    stage("Prepare") {
        sh "cordova platform add $platform"
        sh "cordova prepare $platform"
    }

    stage("Build") {
        if (platform == 'android') {
            if (buildType == 'debug') {
               sh 'cordova build $platform --buildConfig build.json'
            } else {
               sh 'cordova build $platform --release'
            }
        }
    }

    stage("Sign") {
        if (platform == 'android') {
            if (params.BUILD_CONFIG == 'release') {
                signAndroidApks (
                    keyStoreId: "${params.BUILD_CREDENTIAL_ID}",
                    keyAlias: "${params.BUILD_CREDENTIAL_ALIAS}",
                    apksToSign: "platforms/android/**/*-unsigned.apk",
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
    }

    stage("Archive") {
        if (platform == 'android') {
            if (buildType == 'release') {
                archiveArtifacts artifacts: 'platforms/android/build/outputs/apk/android-release.apk', excludes: 'platforms/android/build/outputs/apk/*-unaligned.apk'
            } else {
                archiveArtifacts artifacts: 'platforms/android/build/outputs/apk/android-debug.apk', excludes: 'platforms/android/build/outputs/apk/*-unaligned.apk'
            }
        }
        if (platform == 'ios') {
            if (buildType == 'release') {
                archiveArtifacts artifacts: 'platforms/ios/Build/Debug-iphoneos/release.ipa', excludes: 'platforms/android/build/outputs/apk/*-unaligned.apk'
            } else {
                archiveArtifacts artifacts: 'platforms/ios/Build/Debug-iphoneos/debug.ipa', excludes: 'platforms/android/build/outputs/apk/*-unaligned.apk'
            }
        }
    }
}