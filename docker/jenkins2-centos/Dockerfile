FROM openshift/jenkins-2-centos7

COPY ./contrib/kube-slave-common.sh /usr/local/bin/kube-slave-common.sh

COPY plugins.txt /opt/openshift/configuration/plugins.txt
RUN /usr/local/bin/install-plugins.sh /opt/openshift/configuration/plugins.txt
