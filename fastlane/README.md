# Fastlane samples

This folder contains fastlane actions to build apps in AeroGear Digger for both ios and android.


## Basic usage

To run a "lane" (defined in Fastfile):

```
fastlane $lane_name
```

```
fastlane $lane_name $param1_name:$param1_value $param2_name:$param2_value
```

For example, running the build lane with "debug" config:

```
fastlane build config:debug
```

Please refer to each platform's specific documentation for detailed information:

[iOS Sample](./ios)
[Android Sample](./android)

## AeroGear Digger Usage

Fastlane version: 2.60.1

. Copy the specific platform (ios/android) fastlane folder to the root directory of you application
. Copy/Update Jenkinsfile
+
If you have an existing Jenkinsfile use the `Prepare` and `Build` steps in the provided Jenkinsfile as examples of how to use the fastlane tool in an existing Jenkinsfile
+
If do not have an existing Jenkinsfile, copy the Jenkinsfile from the specific platform fastlane folder to the root directory of you application.

. Trigger a build in your AeroGear Digger instance.
