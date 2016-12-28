FROM aerogear/android-sdk-sti

MAINTAINER Luigi Zuccarelli <lzuccare@redhat.com>

ENV ANDROID_SDK_INSTALLER=1.0.0
ENV ANDROID_HOME=/opt/install

LABEL io.k8s.description="Utility for installing android sdk" \
      io.k8s.display-name="jenkins android sdk installer" \
      io.openshift.tags="jenkins-android-sdk installer"

USER root 

RUN yum install -y wget && mkdir -p /opt/install && chown -R 1001:1001 /opt/install && chmod -R 777 /opt/install

COPY ./scripts/bin/ /usr/local/bin

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.10.3
ENV DOCKER_SHA256 d0df512afa109006a450f41873634951e19ddabf8c7bd419caeb5a526032d86d

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
	&& echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
	&& chmod +x /usr/local/bin/docker

RUN wget --output-document=s2i.tgz --quiet https://github.com/openshift/source-to-image/releases/download/v1.1.3/source-to-image-v1.1.3-ddb10f1-linux-386.tar.gz && \
tar xzf s2i.tgz && \
cp s2i /usr/local/bin/ && \
cp sti /usr/local/bin/ && \
chmod +x /usr/local/bin/s2i 

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

WORKDIR /opt/install
#USER 1001

ENTRYPOINT ["/usr/local/bin/run"]