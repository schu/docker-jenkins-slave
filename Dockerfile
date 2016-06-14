# Adapted from https://github.com/evarga/docker-images/tree/master/jenkins-slave

FROM ubuntu:xenial

RUN locale-gen en_US.UTF-8 && \
    apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends \
    build-essential \
    curl \
    debhelper \
    dpkg-dev \
    fakeroot \
    gcc \
    git \
    golang \
    jq \
    lsb-release \
    make \
    mercurial \
    openssh-server \
    && \
    apt-get -q autoremove && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openjdk-8-jre-headless && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

ADD gvt /usr/local/bin/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
