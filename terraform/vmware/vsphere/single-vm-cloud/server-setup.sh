#!/bin/sh

sudo rm -rf /etc/netplan/*.yaml

sudo bash -c 'cat << EOF > /etc/netplan/50-cloud-init.yaml
instance-id: test3-ubuntu22
local hostname: test3-ubuntu22
network:
  version: 2
  ethernets:
    nics:
      match:
        name: ens*
      dhcp4: false
      addresses:
        - 10.0.0.89/24
      gateway4: 10.0.0.1
      nameservers:
        addresses:
          - 10.0.0.33
          - 8.8.8.8
          - 8.8.4.4
EOF'

sudo netplan apply
