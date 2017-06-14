FROM centos:7

MAINTAINER AeroGear Team <https://aerogear.org/>

USER root

#env vars
ENV JAVA_HOME=/etc/alternatives/java_sdk_1.8.0 \
  ANDROID_HOME=/opt/android-sdk-linux \
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
  wget \
  expect

#install dependencies and links androidctl cli to /usr/bin
RUN curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py' && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install -U -r /opt/tools/requirements.txt && \
    mkdir -p ${ANDROID_HOME} && \
    chmod 775 -R /opt && \
    ln -s /opt/tools/androidctl-bin /usr/bin/androidctl && \
    mkdir $HOME/.android && \
    chmod 775 $HOME/.android && \
    ln -s $ANDROID_HOME/android.debug  $HOME/.android/android.debug

CMD ["sleep", "infinity"]
