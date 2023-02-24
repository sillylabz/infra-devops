#!/bin/sh
server_ip=$1
server_hostname=$2

sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg <<EOF
network: {config: disabled}
EOF

sudo tee /etc/netplan/50-cloud-init.yaml <<EOF
network:
  version: 2
  ethernets:
    nics:
      match:
        name: ens4
      dhcp4: false
      addresses:
        - $server_ip/24
      gateway4: 10.0.0.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
EOF

sudo hostnamectl set-hostname $server_hostname && \
    sudo reboot

