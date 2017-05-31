FROM openshift/jenkins-slave-base-centos7

MAINTAINER AeroGear Team <https://aerogear.org/>

ENV ANDROID_SLAVE_SDK_BUILDER=1.0.0

LABEL io.k8s.description="Platform for building slave android sdk image" \
      io.k8s.display-name="jenkins android sdk slave builder" \
      io.openshift.tags="jenkins-android-slave builder"

ENV NODEJS_VERSION=4.4 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    # As we don't execute the scl_enable command here we incldue both PATH and LD_LIBRARY_PATH envars
    # inorder to execute npm install cordova
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:/opt/rh/rh-nodejs4/root/usr/bin:/usr/lib/jvm/java-1.8.0-openjdk/bin:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    LD_LIBRARY_PATH=/opt/rh/rh-nodejs4/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk \
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


COPY usr/bin/run-jnlp.sh /usr/local/bin/run-jnlp.sh 


RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

# Install Cordova
RUN npm install -g cordova

# setup workspace
RUN mkdir -p /opt/workspace

# This default user is created in the openshift/base-centos7 image
USER 1001
WORKDIR /opt/workspace

# Set the entry point
ENTRYPOINT ["/usr/local/bin/run-jnlp.sh"]
