# digger-jenkins
Digger on Jenkins: An OpenSource Build Farm for mobile app builds in the cloud

Give us mobile app source code and we would build it for you!

![](http://i.imgur.com/XmDnbeo.jpg)

## Purpose of the project

Provide complete mobile build solution on top of Jenkins and OpenShift platforms.

## How to use it

Digger would allow you to build your mobile apps (and any other apps) using instruction provided in `Jenkinsfile` located in your code.
To create digger jenkins use openshift template provided in this repository and download one of the clients to interact with the server.
You can also login directly to jenkins ui and customize it for your own needs.

## Clients

Use one of the clients bellow to interact with the digger jenkins api.

- Node.js command line client and library:
https://github.com/aerogear/digger-node

- Java library: https://github.com/aerogear/digger-java

## Repo structure

Please check individual folders for more information

### `/docker` folder
Contains custom Jenkins Dockerfiles.

[See the readme](../master/docker)

### `/openshift`
Contains OpenShift Container Platform templates

[See the readme](../master/openshift)

### `/jenkinsfiles`
Contains Jenkins job definitions for each platform

[See the readme](../master/jenkinsfiles)
