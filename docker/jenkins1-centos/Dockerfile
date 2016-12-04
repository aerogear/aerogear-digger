FROM openshift/jenkins-1-centos7

USER root

# needed to wget the android sdk
RUN yum install -y wget

COPY ./contrib/kube-slave-common.sh /usr/local/bin/kube-slave-common.sh

COPY plugins.txt /opt/openshift/configuration/plugins.txt
RUN /usr/local/bin/plugins.sh /opt/openshift/configuration/plugins.txt

# needed for gradlew 
ENV JAVA_HOME=/etc/alternatives/java_sdk_1.8.0_openjdk