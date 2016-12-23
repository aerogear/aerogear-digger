FROM openshift/jenkins-2-centos7

USER root

RUN mkdir -p /usr/local/bin/aerogear

COPY ./contrib/kube-slave-common.sh       /usr/local/bin/kube-slave-common.sh
COPY ./contrib/install-plugins.sh         /usr/local/bin/install-plugins.sh
COPY ./contrib/aerogear/*                 /usr/local/bin/aerogear/

## make the Aerogear scripts executable
RUN chmod +x /usr/local/bin/aerogear/*

COPY plugins.txt /opt/openshift/configuration/plugins.txt

USER 1001

RUN /usr/local/bin/install-plugins.sh /opt/openshift/configuration/plugins.txt

RUN mkdir $JENKINS_HOME/secrets && \
    echo "false" > $JENKINS_HOME/secrets/slave-to-master-security-kill-switch && \
    ## Prevent admins from changing master to slave security option
    chmod 444 $JENKINS_HOME/secrets/slave-to-master-security-kill-switch


# we use our own command to execute s2i run
CMD ["/usr/local/bin/aerogear/jenkins-run.sh"]
