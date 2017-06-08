#FROM openshift/base-centos7:latest
FROM centos:7

MAINTAINER AeroGear Team <https://aerogear.org/>

USER root

#env vars
ENV JAVA_HOME=/etc/alternatives/java_sdk_1.8.0 \
  ANDROID_HOME=/opt/android-sdk-linux \
  ANDROID_CONFIG=/opt/android-config \
  HOME=/root

#tools folder
COPY tools /opt/tools

#system packages
RUN yum install -y \
  zlib.i686 \
  ncurses-libs.i686 \
  bzip2-libs.i686 \
  java-1.8.0-openjdk-devel \
  java-1.8.0-openjdk \
  ant \
  which\
  wget && \
  yum groupinstall -y "Development Tools" && \
  wget http://jensd.be/download/inotify-tools-3.14.tar.gz && \
  tar -zxvpf inotify-tools-3.14.tar.gz && \
  (cd inotify-tools-3.14; ./configure && make && make install) && \
  rm -rf inotify-tools-3.14*

#install dependencies and links androidctl cli to /usr/bin
RUN curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py' && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install -U -r /opt/tools/requirements.txt && \
    mkdir -p ${ANDROID_CONFIG} ${ANDROID_HOME} && \
    chmod 775 -R /opt && \
    ln -s ${ANDROID_CONFIG} ${HOME}/.android && \
    ln -s /opt/tools/androidctl /usr/bin/androidctl

CMD ["bash", "-c", "/opt/tools/watch"]
