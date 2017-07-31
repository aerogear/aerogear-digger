/**
* IOS Jenkinsfile
*/

//     in RHMAP's case, following parameters are sent by RHMAP to Jenkins job.
//     this means, Jenkins job has to be a parametrized build with those parameter.
CODE_SIGN_PROFILE_ID = params?.BUILD_CREDENTIAL_ID?.trim()                 // e.g. "redhat-dist-dp"
BUILD_CONFIG = params?.BUILD_CONFIG?.trim()                                // e.g. "Debug" or "Release"

//     if you would like to hardcode these, do it this way
//CODE_SIGN_PROFILE_ID = "redhat-dist-dp"
//BUILD_CONFIG = "Debug"

// sample values commented below are for https://github.com/feedhenry-templates/helloworld-ios-swift
/* ------------- use these to hardcode things in Jenkinsfile ---------------- */
PROJECT_NAME = "helloworld-ios-app"
INFO_PLIST = "helloworld-ios-app/helloworld-ios-app-Info.plist"
VERSION = "0.1-alpha"
SHORT_VERSION = "0.1"
BUNDLE_ID = "com.feedhenry.helloworld-ios-app"
OUTPUT_FILE_NAME = "myapp.ipa"
SDK = "iphoneos"

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
SDK = params?.OUTPUT_FILE_NAME?.trim() ?: "iphoneos"                // if not set, "iphoneos" will be used

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

// RHMAP specific things. RHMAP currently sends build config type all lower case. we handle it here as case matters for Xcode.
// also, RHMAP can send "Distribution" config. we use "Release" in that case.
if(BUILD_CONFIG.toLowerCase() == "debug"){
    BUILD_CONFIG = "Debug"
}
else if(BUILD_CONFIG.toLowerCase() == "release" || BUILD_CONFIG.toLowerCase() == "distribution"){
    BUILD_CONFIG = "Release"
}

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
                    sdk: "${SDK}",
                    version: "${VERSION}",
                    shortVersion: "${SHORT_VERSION}",
                    bundleId: "${BUNDLE_ID}",
                    infoPlistPath: "${INFO_PLIST}",
                    flags: '-fstack-protector -fstack-protector-all ENABLE_BITCODE=NO',
                    autoSign: false,
                    config: "${BUILD_CONFIG}"
            )
        }
    }

    stage('CodeSign') {
        codeSign(
                profileId: "${CODE_SIGN_PROFILE_ID}",
                clean: CLEAN,
                verify: true,
                ipaName: "${OUTPUT_FILE_NAME}",
                appPath: "build/${BUILD_CONFIG}-${SDK}/${PROJECT_NAME}.app"
        )
    }

    stage('Archive') {
        archiveArtifacts "build/${BUILD_CONFIG}-${SDK}/${OUTPUT_FILE_NAME}"
    }
}
