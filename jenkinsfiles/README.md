## Mobile Application configurations

This folder contains Jenkins pipeline definitions for mobile app builds.

Please refer to specific platform and architecture for more information.

## `jenkinsfile`s

Files have groovy extension to support syntax highlighting.
When moving to repositories they should be renamed to `jenkinsfile`.

- `android_jenkinsfile.groovy`
- `cordova_jenkinsfile.groovy`

## Development

Pipeline files can be modified for your own needs as long as commands/plugins would launch on the Kubernetes node (Docker slave).

Please follow general Jenkins pipelines documentation here: <https://jenkins.io/doc/book/pipeline/jenkinsfile/>
