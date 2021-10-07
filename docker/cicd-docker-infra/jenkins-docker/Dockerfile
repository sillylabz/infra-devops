ARG JENKINS_VER=lts
ARG JENKINS_REGISTRY=jenkins/jenkins
FROM ${JENKINS_REGISTRY}:${JENKINS_VER}

# switch to root, let the entrypoint drop back to jenkins
USER root

# install prerequisite debian packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
        vim \
        wget \
    && mkdir -p /java-apps \
    && chown jenkins:jenkins /java-apps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install gosu for a better su+exec command
ARG GOSU_VERSION=1.10
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true 

# install docker
ARG DOCKER_CLI_VERSION=19.03.0~3-0~debian-stretch
COPY entrypoint.sh /entrypoint.sh
# ARG DOCKER_CLI_VERSION=
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
         stable" \
    && apt-get update \
    && apt-get clean \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        docker-ce docker-ce-cli containerd.io \
    && service docker start \
    && service docker status \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /entrypoint.sh

# entrypoint is used to update docker gid and revert back to jenkins user
ENTRYPOINT ["/entrypoint.sh"]
