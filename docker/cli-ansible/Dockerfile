# Apline Linux base image
FROM alpine:3.15

ENV ANSIBLE_VERSION 5.1.0
ENV TERRAFORM_VER 1.1.2
ENV GLIBC_VER 2.31-r0

RUN apk --no-cache add \
        binutils \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        bash \
        curl \
        unzip \
        jq \
        git \
        # install glibc compatibility for the AWS CLI v2 and the CLI
        && curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
        && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
        && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
        && apk add --no-cache \
            glibc-${GLIBC_VER}.apk \
            glibc-bin-${GLIBC_VER}.apk \
        && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
        && unzip awscliv2.zip \
        && aws/install \
        && rm -rf \
            awscliv2.zip \
            aws \
            /usr/local/aws-cli/v2/*/dist/aws_completer \
            /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
            /usr/local/aws-cli/v2/*/dist/awscli/examples \
        && apk add --no-cache --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base && \
    pip3 install --upgrade pip cffi && \
    pip3 install ansible==${ANSIBLE_VERSION} && \
    pip3 install mitogen ansible-lint jmespath && \
    pip3 install --upgrade pywinrm \
    # Install eksctl (The official CLI for Amazon EKS)
    && curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin \
    # Install kubectl (The Kubernetes command-line tool)
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    # Install helm3
    && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh \
    # Install terraform
    && curl https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip -o terraform_${TERRAFORM_VER}_linux_amd64.zip \ 
    && unzip terraform_${TERRAFORM_VER}_linux_amd64.zip \ 
    && mv terraform /usr/local/bin/
    

# cleanup
RUN apk del build-dependencies \
        && rm glibc-${GLIBC_VER}.apk \
        && rm glibc-bin-${GLIBC_VER}.apk \
        && rm -rf /var/cache/apk/* \
        && rm -rf /tmp/*


RUN /bin/bash -c "echo \"PS1='\[\033[01;34m\]devops-toolkit:\[\033[00m\]\[\033[01;32m\]\W\[\033[00m\]\[\033[01;34m\]\$\[\033[00m\] '\" >> /root/.bashrc "

