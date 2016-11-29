## Mobile Application configurations

Folder contains Jenkins pipeline definitions for mobile app builds. 
Please refer to specific platform and architecture for more information.

## Jenkinsfiles

Files have groovy extension to support syntax higlighing.
When moving to repositories they should be renamed to `Jenkinsfile`.

- android_jenkinsfile.groovy
- cordova_jenkinsfile.groovy

## Development

Pipeline files can be modifed for your own needs as long they would launch on the kubernetes node (docker slave).
Please follow general Jenkins pipelines documentation here: https://jenkins.io/doc/book/pipeline/jenkinsfile/
