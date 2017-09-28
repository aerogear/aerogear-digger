# Android Fastlane Sample

## Actions

### Build

Builds an android app using the builtin gradle action.


#### Parameters

| parameter |  type  | required | default value |  value options |                               description                               |
|:---------:|:------:|:--------:|:-------------:|:--------------:|:-----------------------------------------------------------------------:|
|   clean   |  bool  |    no    |      true     |   true, false  | Will clean the project before the build phase if it set to true         |
|   config  | string |    no    |     debug     | debug, release | Sets the gradle build task to be run (assembleDebug or assembleRelease) |


#### Examples

Does not clean previous build and runs a debug build:

```
fastlane build clean:false config:debug
```

Cleans the previous build files and runs a release build

```
fastlane build clean:true config:release
```

Runs a debug build by default

```
fastlane build
```

### Sign

Signs the generated apk  with jarsign and zipalign

#### Parameters

|   parameter   |  type  | required | default value | value options |                                             description                                            |
|:-------------:|:------:|:--------:|:-------------:|:-------------:|:--------------------------------------------------------------------------------------------------:|
|     alias     | string |    yes   |               |               | Keystore alias                                                                                     |
|   storepass   | string |    yes   |               |               | Keystore store password                                                                            |
|    keypass    | string |    yes   |               |               | Keystore key password                                                                              |
| keystore_path | string |    yes   |               |               | Keystore file path                                                                                 |
|    apk_path   | string |    yes   |               |               | APK file path to be signed/aligned by jarsign and zipalign                                         |
|   build_tool  | string |    yes      |               |               | Build tool version to be used by zipalign, the same version that is used in your build.gradle file |

#### Examples

````
fastlane sign alias:android_release storepass:android keypass:android keystore_path:/path/to/keystore apk_path:/path/to/apk build_tool:25.0.3
```
