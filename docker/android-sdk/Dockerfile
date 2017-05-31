FROM centos:7

MAINTAINER AeroGear Team <https://aerogear.org/>

USER root

#env vars
ENV JAVA_HOME /etc/alternatives/java_sdk_1.8.0
ENV ANDROID_HOME /opt/android-sdk-linux
ENV HOME /root

#tools folder
COPY tools /opt/tools

#system packages
RUN yum install -y \
  wget \
  tar \
  unzip \
  zlib.i686 \
  ncurses-libs.i686 \
  bzip2-libs.i686 \
  java-1.8.0-openjdk-devel \
  java-1.8.0-openjdk \
  ant \
  which

#install dependencies and links androidctl cli to /usr/bin
RUN chmod 770 /root && chmod 770 /opt && \
  curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py' && \
  python get-pip.py && \
  rm get-pip.py && \
  pip install -U -r /opt/tools/requirements.txt && \
  ln -s /opt/tools/androidctl /usr/bin/androidctl && \
  chmod 755 /opt/tools/androidctl

CMD ["sleep", "infinity"]
