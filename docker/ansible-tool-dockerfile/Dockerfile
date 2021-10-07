FROM alpine:3.11

ENV ANSIBLE_VERSION 2.9.9

RUN apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base && \
    pip3 install --upgrade pip cffi && \
    pip3 install ansible==${ANSIBLE_VERSION} && \
    pip3 install mitogen ansible-lint jmespath && \
    pip3 install --upgrade pywinrm && \
    pip3 install openshift pyyaml kubernetes  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /ansible && \
    # mkdir -p /ansible/.kube/ && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

# COPY kube-config /ansible/.kube/config

RUN set -x && \ 
    \
    echo "==> Installing k8s ansible module..." && \
    ansible-galaxy collection install community.general 

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]

