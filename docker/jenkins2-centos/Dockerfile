FROM openshift/jenkins-2-centos7

MAINTAINER AeroGear Team <https://aerogear.org/>

USER root

# rename the run script from base image so that we can use it
RUN mv /usr/libexec/s2i/run /usr/libexec/s2i/run-base

# copy our custom Jenkins scripts
COPY ./contrib/jenkins /usr/local/bin

# copy the s2i scripts. s2i expects them to be in /usr/libexec/s2i by default.
COPY ./contrib/s2i /usr/libexec/s2i

# make the copied s2i scripts executable
RUN chmod -R +x /usr/libexec/s2i/*

COPY plugins.txt /opt/openshift/configuration/plugins.txt

USER 1001

RUN /usr/local/bin/install-plugins.sh /opt/openshift/configuration/plugins.txt && \
    # configure slave to master security
    mkdir $JENKINS_HOME/secrets && \
    echo "false" > $JENKINS_HOME/secrets/slave-to-master-security-kill-switch && \
    ## Prevent admins from changing master to slave security option
    chmod 444 $JENKINS_HOME/secrets/slave-to-master-security-kill-switch

CMD ["/usr/libexec/s2i/run"]
