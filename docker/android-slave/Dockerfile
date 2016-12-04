FROM openshift/jenkins-slave-base-centos7

MAINTAINER Wojciech Trocki <wtr@redhat.com>

ENV NODEJS_VERSION=4.4 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# Install NodeJS
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS

# Install Java
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

# Install build dependencies
RUN yum install -y git wget python curl expect expectk

# Copy install tools
COPY tools /opt/tools
ENV PATH ${PATH}:/opt/tools

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace

USER 1001
