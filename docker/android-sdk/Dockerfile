FROM openshift/base-centos7:latest

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
  ant \
  inotify-tools && \
  wget http://jensd.be/download/inotify-tools-3.14.tar.gz && \
  tar -zxvpf inotify-tools-3.14.tar.gz && \
  (cd inotify-tools-3.14; ./configure && make && make install) && \
  rm -rf inotify-tools-3.14*

#install dependencies and links androidctl cli to /usr/bin
RUN curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py' && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install -U -r ${HOME}/tools/requirements.txt && \
    ln -s ${HOME}/tools/androidctl /usr/bin/androidctl && \
    chmod -R  664 ${HOME} && \
    chown -R default:root ${HOME} && \
    setfacl -d -m u::rw ${HOME} && \
    setfacl -d -m g::rw ${HOME} && \
    setfacl -d -m o::r ${HOME} && \
    mkdir -p ${HOME}/.android

USER default

WORKDIR ${HOME}

CMD ["bash", "-c", "$HOME/tools/watch", ">", "$HOME/android-sdk-watch.log"]
