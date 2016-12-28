# OpenShift 3 Jenkins Templates

## Running Digger on existing OpenShift instance


#### Prerequisites:
- Dedicated OpenShift project (namespace) for jenkins and created build slaves
- Persistent volume (by default 50Gi, but it can be changed for different needs)

#### Steps:
1. Point OpenShift client to project you want to use for jenkins

        oc project your-project-name

1. Execute template

        oc new-app -f ./jenkins-persistent-template.json


## Running jenkins on local machine (dev setup)

This sample walks through the process of starting up an OpenShift cluster and deploying a Jenkins Pod in it.

#### Steps


1. Unless you have built OpenShift locally, be sure to grab the [oc command, v1.3+](https://github.com/openshift/origin/releases/tag/v1.3.1)

1. Stand up an OpenShift cluster from origin master, installing the standard image streams to the OpenShift namespace:

        oc cluster up

1. Setup simple persistent volume on new cluster execute:

**Note**: jenkins-persistent-template.json template file requires an OpenShift persistent volume.
Persistent volume setup is not part of the template and require separate steps.
If you already have persistent volumes feel free to skip this step.

        rm -R /tmp/jenkins
        mkdir -p /tmp/jenkins
        chmod -R 777 /tmp/jenkins
        # creating a cluster wide persistent volume like the one we use requires
        # an admin user on OpenShift.
        oc login -u system:admin
        oc create -f ./sample-pv.json

Note that `mkdir` and `chmod` commands above should be executed in the Docker-machine, in case of using Docker-machine (boot2docker) on Mac.

1. Login as a normal user (any non-empty user name and password is fine)

        oc login

1. Create a project  named "test"

        oc new-project test

1. Run this command to instantiate a Jenkins server and service account in your project:

    If your have persistent volumes available in your cluster:

        oc new-app -f ./jenkins-persistent-template.json

1. View/Manage Jenkins

    If you have a router running (`oc cluster up` provides one), run:

        oc get route

    and access the host for the Jenkins route.

    If you do not have a router or your host system does not support xip.io name resolution, you can access jenkins directly via the service ip.  Determine the jenkins service ip ("oc get svc") and go to it in your browser on port 80.  Do not confuse it with the jenkins-jnlp service.

    Login with the `admin` user name and password ${JENKINS_PASSWORD}.

## Plugins

You can work with Jenkins sample and demonstrate the use of the [Kubernetes plugin](https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin) to manage
Jenkins slaves that run as on-demand Pods. Kubernetes plugin is pre-installed into the OpenShift Jenkins Images
for CentOS and RHEL produced by the [OpenShift Jenkins repository](https://github.com/openshift/jenkins).

OpenShift Jenkins repository also produces a [base Jenkins slave image](https://github.com/openshift/jenkins/tree/master/slave-base),
as well as Jenkins slave images for [Maven](https://github.com/openshift/jenkins/tree/master/slave-maven) and
[NodeJS](https://github.com/openshift/jenkins/tree/master/slave-nodejs) which extend that base Jenkins slave image.

These next set of steps build upon the steps just executed above, leveraging the OpenShift Jenkins slave image for NodeJS to launch the sample
job in a Jenkins slave provisioned as Kubernetes Pod on OpenShift.

## OSX slave setup

It is not possible to run OSX in a container, thus we need to connect our OpenShift cluster to an OSX system outside of OpenShift.
In Jenkins terms, it is an "OSX agent" or "OSX slave".

In order to do that, you must first configure the OSX system. This will be replaced by an Ansible script in the future.

All of the following operations on OSX machine requires `sudo`.

First, create a Jenkins user on your OSX machine with username `jenkins` and password `Password1`:

        . /etc/rc.common
        dscl . create /Users/jenkins
        dscl . create /Users/jenkins RealName "Jenkins Agent"
        dscl . passwd /Users/jenkins Password1
        # the first user's id is 500, second is 501...
        # picking a big number to be on the safe side
        # You can run this one to list UIDs
        #   dscl . -list /Users UniqueID
        dscl . create /Users/jenkins UniqueID 550
        # GID 20 is `staff`
        dscl . create /Users/jenkins PrimaryGroupID 20
        dscl . create /Users/jenkins UserShell /bin/bash
        dscl . create /Users/jenkins NFSHomeDirectory /Users/jenkins
        cp -R /System/Library/User\ Template/English.lproj /Users/jenkins
        chown -R jenkins:staff /Users/jenkins

Then, enable remote login (ssh) for the machine and for this user:

        systemsetup -setremotelogin on
        # in order to check what groups are are there:
        #   dscl . list /Groups PrimaryGroupID
        # create a group for limiting SSH access
        dseditgroup -o create -q com.apple.access_ssh
        # add user into this group
        dseditgroup -o edit -a jenkins -t user com.apple.access_ssh
        # now, following should work
        #   ssh jenkins@localhost

Create a working folder for the agent:

        mkdir -p /opt/jenkins
        chown -R jenkins /opt/jenkins


Note that you need to pass `jenkins` as `${OSX_SLAVE_USERNAME}` and `Password1` as `${OSX_SLAVE_PASSWORD}` while creating the OpenShift application
from template (`jenkins-persistent-template.json`).


## Troubleshooting

* Fedora

 * SELinux

On Fedora you need to ensure the Docker Daemon is running without `SELinux`. In `/etc/sysconfig/docker` the `OPTIONS` should *not* contain `--selinux-enabled` option:

        OPTIONS='--log-driver=journald'

 * iptables

It's also recommended to run `sudo iptables -F` before getting started.

 * DNS problems with `xip.io`

In case your machine is not able to resolve the `xip.io` domain names of your pods, make sure you add Google's DNS server to `/etc/resolve.conf`:

        nameserver 8.8.8.8
