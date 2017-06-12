FROM openshift/base-centos7

MAINTAINER AeroGear Team <https://aerogear.org/>

USER root

#env vars
ENV JAVA_HOME /etc/alternatives/java_sdk_1.8.0
ENV ANDROID_HOME ${HOME}/android-sdk-linux

#tools folder
COPY tools ${HOME}/tools

#system packages
RUN yum install -y \
  zlib.i686 \
  ncurses-libs.i686 \
  bzip2-libs.i686 \
  java-1.8.0-openjdk-devel \
  java-1.8.0-openjdk \
  ant

#install dependencies and links androidctl cli to /usr/bin
RUN curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py' && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install -U -r ${HOME}/tools/requirements.txt && \
    ln -s ${HOME}/tools/androidctl /usr/bin/androidctl && \
    chmod -R  777 ${HOME} && \
    chown -R default:root ${HOME}

USER default

WORKDIR ${HOME}

CMD ["sleep", "infinity"]
