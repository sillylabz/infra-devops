FROM ubuntu:22.04

ENV ANSIBLE_VERSION 7.4.0
ENV TERRAFORM_VER 1.4.3
ENV TERRAGRUNT_VER v0.45.0
ENV EKSA_RELEASE 0.15.1
ENV RELEASE_NUMBER latest
WORKDIR /root

RUN apt-get update -y && apt-get install \
    curl \
    wget \
    jq \
    unzip \
    python3 \
    python3-pip \
    python3-setuptools \
    groff \
    less \
    -y && \
    pip3 --no-cache-dir install --upgrade \
        awscli \
        yq \
        ansible && \
    rm -Rf /root/.cache/pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
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
    && mv terraform /usr/local/bin/ \
    # Install terragrunt
    && wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VER}/terragrunt_linux_amd64 -O terragrunt \
    && chmod +x terragrunt \ 
    && mv terragrunt /usr/local/bin/ 
    # Install docker
    
    


