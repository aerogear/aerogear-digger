FROM openshift/jenkins-2-centos7

RUN mkdir -p /usr/local/bin/aerogear

COPY ./contrib/kube-slave-common.sh   /usr/local/bin/kube-slave-common.sh
COPY ./contrib/aerogear/*             /usr/local/bin/aerogear/

COPY plugins.txt /opt/openshift/configuration/plugins.txt
RUN /usr/local/bin/install-plugins.sh /opt/openshift/configuration/plugins.txt && \
    mkdir $JENKINS_HOME/secrets && \
    echo "false" > $JENKINS_HOME/secrets/slave-to-master-security-kill-switch && \
    ## Prevent admins from changing master to slave security option
    chmod 444 $JENKINS_HOME/secrets/slave-to-master-security-kill-switch && \
    ## make the Aerogear scripts executable
    chmod +x /usr/local/bin/aerogear/*.sh

# we use our own command to execute s2i run
CMD ["/usr/local/bin/aerogear/jenkins-run.sh"]
