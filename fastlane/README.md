# Fastlane samples

This folder contains fastlane actions to build apps in diggger-jenkins for both ios and android.


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

## Digger-jenkins usage

Fastlane version: 2.60.1

Copy the specific platform (ios/android) fastlane folder and Jenkinsfile to your project root's folder and trigger a build in your digger-jenkins instance.
