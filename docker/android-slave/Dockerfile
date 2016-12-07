
FROM aerogear/jenkins-slave-base:1.0.0

MAINTAINER Luigi Zuccarelli <lzuccare@redhat.com>

ENV ANDROID_SLAVE_SDK_BUILDER=1.0.0

LABEL io.k8s.description="Platform for building slave android sdk image" \
      io.k8s.display-name="jenkins android sdk slave builder" \
      io.openshift.tags="jenkins-android-slave builder"

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


# Setup directory for the android sdk 
RUN mkdir -p /opt/android-sdk-linux && chmod -R 777 /opt/android-sdk-linux
RUN mkdir -p /home/jenkins/.android && chmod -R 777 /home/jenkins/.android

# setup workspace
RUN mkdir -p /opt/workspace

# setup for s2i builds
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
COPY ./.s2i/bin/ /usr/local/s2i

# This default user is created in the openshift/base-centos7 image
USER 1001
WORKDIR /opt/workspace
CMD ["usage"]