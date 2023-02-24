#!/bin/sh

k8s_version="1.24.7-00"

sudo tee /etc/hosts <<EOF
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
10.0.0.32   tool-k8s-master1.labz.io tool-k8s-master1
10.0.0.33   tool-k8s-node1.labz.io tool-k8s-node1
10.0.0.34   tool-k8s-node2.labz.io tool-k8s-node2
10.0.0.35   tool-k8s-node3.labz.io tool-k8s-node3
EOF

sudo swapoff -a && \
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab;


sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay;
sudo modprobe br_netfilter;


sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system;


sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates && \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg && \
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    sudo apt update -y && sudo apt install -y containerd.io && \
    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1 && \
    sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml && \
    sudo systemctl restart containerd && sudo systemctl enable containerd;


curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    sudo apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main" && \
    sudo apt-get update -y && \
    sudo apt-get install -y podman ufw && \
    sudo apt-get install -y kubelet=$k8s_version kubeadm=$k8s_version kubectl=$k8s_version && \
    sudo apt-mark hold kubelet kubeadm kubectl;


