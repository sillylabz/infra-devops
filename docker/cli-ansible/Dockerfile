# Amazon Linux 2 is the next generation of Amazon Linux
FROM amazonlinux:2

# Install necessary packages:
#   - bind-utils and telnet for network utils
#   - groff and less are needed by aws install
#   - python2-pip for cqlsh
#   - python3-pip for ansible
#   - java for java based framework commands
#   - openssl for helm install
#   - mysql for mysql client
RUN yum update -y \
    && yum install -y \
    unzip tar gzip \
    curl wget bind-utils telnet \
    groff less \
    python2-pip \
    python3-pip \
    java-1.8.0 \
    openssl \
    mysql \
    git emacs

# Intall AWS CLI version 2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm awscliv2.zip

# Install eksctl (The official CLI for Amazon EKS)
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/0.40.0/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin

# Install kubectl (The Kubernetes command-line tool)
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Install Kafka for client utilities and testing
RUN curl -s https://archive.apache.org/dist/kafka/2.2.1/kafka_2.12-2.2.1.tgz | tar xz \
    && mv kafka_2.12-2.2.1 kafka

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh


# Install ansible
RUN python3 -m pip install -U pip
RUN pip3 install -I openshift==0.12.0
RUN pip3 install ansible ansible-lint PyYAML boto3
RUN ansible-galaxy collection install community.kubernetes community.aws
COPY ansible.cfg hosts /


# Install terraform
ARG TERRAFORM_VER=0.14.3
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip -o terraform_${TERRAFORM_VER}_linux_amd64.zip \ 
&& unzip terraform_${TERRAFORM_VER}_linux_amd64.zip \ 
&& mv terraform /usr/local/bin/


RUN /bin/bash -c "echo \"PS1='\[\033[01;34m\]zcli:\[\033[00m\]\[\033[01;32m\]\W\[\033[00m\]\[\033[01;34m\]\$\[\033[00m\] '\" >> /root/.bashrc "
RUN /bin/bash -c "echo \"alias ll='ls -a -l'\" >> /root/.bashrc "
