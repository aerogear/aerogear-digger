OpenShift 3 Jenkins
=========================
This sample walks through the process of starting up an OpenShift cluster and deploying a Jenkins Pod in it.

Steps
-----

1. Unless you have built OpenShift locally, be sure  to grab the [oc command, v1.3+](https://github.com/openshift/origin/releases/tag/v1.3.1)

1. Stand up an openshift cluster from origin master, installing the standard imagestreams to the openshift namespace:

        $ oc cluster up

1. Login as a normal user (any non-empty user name and password is fine)

        $ oc login

1. Create a project  named "test"

        $ oc new-project test

1. Create persistent volume 

**Note**: jenkins-persistent-template.json template file requires openshift persistent volume.
Persistent volume setup is not part of the template and require separate steps. 
If you already have persistent volumes feel free to skip this step.
To setup simple persistent volume on new cluster execute:
        
        $ mkdir /tmp/jenkins
        $ chmod 777 /tmp/jenkins
        $ oc login -u system:admin
        $ oc create -f ./sample-pv.json

1. Run this command to instantiate a Jenkins server and service account in your project:

    If your have persistent volumes available in your cluster:

        $ oc new-app -f ./jenkins-persistent-template.json
    
1. View/Manage Jenkins

    If you have a router running (`oc cluster up` provides one), run:

        $ oc get route

    and access the host for the Jenkins route.

    If you do not have a router or your host system does not support xip.io name resolution, you can access jenkins directly via the service ip.  Determine the jenkins service ip ("oc get svc") and go to it in your browser on port 80.  Do not confuse it with the jenkins-jnlp service.

    Login with the `admin` user name and password ${JENKINS_PASSWORD}.

Plugins
------

You can work with jenkins sample and demonstrate the use of the [kubernetes-plugin](https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin) to manage
Jenkins slaves that run as on-demand Pods.  The kubenetes-plugin is pre-installed into the OpenShift Jenkins Images
for Centos and RHEL produced by the [OpenShift Jenkins repository](https://github.com/openshift/jenkins).  The OpenShift
Jenkins repository also produces a [base Jenkins slave image](https://github.com/openshift/jenkins/tree/master/slave-base),
as well as Jenkins slave images for [Maven](https://github.com/openshift/jenkins/tree/master/slave-maven) and
[NodeJS](https://github.com/openshift/jenkins/tree/master/slave-nodejs) which extend that base Jenkins slave image.

These next set of steps builds upon the steps just executed above, leveraging the OpenShift Jenkins slave image for NodeJS to launch the sample
job in a Jenkins slave provisioned as Kubernetes Pod on OpenShift.


More details
------------

* A broader tutorial, including how to create slave images for OpenShift, is [here](https://docs.openshift.org/latest/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).  
