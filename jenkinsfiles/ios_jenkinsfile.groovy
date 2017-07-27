/**
* IOS Jenkinsfile
*/

//     in RHMAP's case, following parameter is sent by RHMAP to Jenkins job.
//     this means, Jenkins job has to be a parametrized build with that parameter.
CODE_SIGN_PROFILE_ID = params?.BUILD_CREDENTIAL_ID.trim()                 // e.g. "redhat-dist-dp"
//     if you would like to hardcode it, do it this way
//CODE_SIGN_PROFILE_ID = "redhat-dist-dp"

// sample values commented below are for https://github.com/feedhenry-templates/helloworld-ios-swift
/* ------------- use these to hardcode things in Jenkinsfile ---------------- */
PROJECT_NAME = "helloworld-ios-app"
INFO_PLIST = "helloworld-ios-app/helloworld-ios-app-Info.plist"
VERSION = "0.1-alpha"
SHORT_VERSION = "0.1"
BUNDLE_ID = "com.feedhenry.helloworld-ios-app"
OUTPUT_FILE_NAME = "myapp.ipa"

XC_VERSION = ""                       // use something like 8.3 to use a specific XCode version.
                                      // if not set, the default Xcode on the machine will be used

CLEAN = true                          // do a clean build and sign


/* ------------- use these to get things from Jenkins parametrized build ---------------- */
/*
PROJECT_NAME = params?.PROJECT_NAME?.trim()                         // e.g. "helloworld-ios-app"
INFO_PLIST = params?.INFO_PLIST?.trim()                             // e.g. "helloworld-ios-app/helloworld-ios-app-Info.plist"
VERSION = params?.APP_VERSION?.trim()                               // e.g. "0.1-alpha"
SHORT_VERSION = params?.APP_SHORT_VERSION?.trim()                   // e.g. "0.1"
BUNDLE_ID = params?.BUNDLE_ID?.trim()                               // e.g. "com.feedhenry.helloworld-ios-app"
OUTPUT_FILE_NAME = params?.OUTPUT_FILE_NAME?.trim() ?: "myapp.ipa"  // if not set, myapp.ipa will be used

XC_VERSION = params?.XC_VERSION?.trim() ?: ""                       // use something like 8.3 to use a specific XCode version.
                                                                    // if not set, the default Xcode on the machine will be used

CLEAN = params?.CLEAN?.trim()?.toBoolean() ?: true                  // default value is true
*/

/*
NOTE: RHMAP sends `BUILD_CONFIG` parameter to denote if it is a debug build or a release build.
      However, from codesign/xcodebuild perspective, the thing we have to do is the same.
      So, we just ignore that parameter.
*/


// parametrized things

FH_CONFIG_CONTENT = params?.FH_CONFIG_CONTENT ?: ""


node('ios') {
    stage('Checkout') {
        checkout scm
    }

    stage('Prepare') {
        writeFile file: "${PROJECT_NAME}/fhconfig.plist", text: FH_CONFIG_CONTENT
        sh '/usr/local/bin/pod install'
    }

    stage('Build') {
        withEnv(["XC_VERSION=${XC_VERSION}"]) {
            xcodeBuild(
                    cleanBeforeBuild: CLEAN,
                    src: './',
                    schema: "${PROJECT_NAME}",
                    workspace: "${PROJECT_NAME}",
                    buildDir: "build",
                    sdk: "iphoneos",
                    version: "${VERSION}",
                    shortVersion: "${SHORT_VERSION}",
                    bundleId: "${BUNDLE_ID}",
                    infoPlistPath: "${INFO_PLIST}",
                    flags: '-fstack-protector -fstack-protector-all ENABLE_BITCODE=NO',
                    autoSign: false
            )
        }
    }

    stage('CodeSign') {
        codeSign(
                profileId: "${CODE_SIGN_PROFILE_ID}",
                clean: CLEAN,
                verify: true,
                ipaName: "${OUTPUT_FILE_NAME}",
                appPath: "build/Debug-iphoneos/${PROJECT_NAME}.app"
        )
    }

    stage('Archive') {
        archiveArtifacts "build/Debug-iphoneos/${OUTPUT_FILE_NAME}"
    }
}
