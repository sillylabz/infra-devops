#!/usr/bin/bash

echo '> Starting Server config actions...'

# install packages
sudo apt -y update && sudo apt-get -y update && sudo apt install -y vim net-tools open-vm-tools iputils-ping

# Prepares a Ubuntu Server guest operating system.
echo > ~/.bash_history
sudo rm -fr /root/.bash_history

# cloud init config

sudo tee /etc/cloud/cloud.cfg <<EOF
users:
   - default

disable_root: true

# This will cause the set+update hostname module to not operate (if true)
preserve_hostname: false

# The modules that run in the 'init' stage
cloud_init_modules:
 - migrator
 - seed_random
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - disk_setup
 - mounts
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - ca-certs
 - rsyslog
 - users-groups
 - ssh
 - runcmd

# The modules that run in the 'config' stage
cloud_config_modules:
 - wireguard
 - snap
 - ubuntu_autoinstall
 - ssh-import-id
 - keyboard
 - locale
 - set-passwords
 - grub-dpkg
 - apt-pipelining
 - apt-configure
 - ubuntu-advantage
 - ntp
 - timezone
 - disable-ec2-metadata
 - runcmd
 - byobu

# The modules that run in the 'final' stage
cloud_final_modules:
 - package-update-upgrade-install
 - fan
 - landscape
 - lxd
 - ubuntu-drivers
 - write-files-deferred
 - puppet
 - chef
 - ansible
 - mcollective
 - salt-minion
 - reset_rmc
 - refresh_rmc_and_interface
 - rightscale_userdata
 - runcmd
 - scripts-vendor
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - install-hotplug
 - phone-home
 - final-message
 - power-state-change

# System and/or distro specific settings
# (not accessible to handlers/transforms)
system_info:
   # This will affect which distro class gets used
   distro: ubuntu
   # Default user name + that default users groups (if added/used)
   default_user:
     name: ubuntu
     lock_passwd: True
     gecos: Ubuntu
     groups: [adm, audio, cdrom, dialout, dip, floppy, lxd, netdev, plugdev, sudo, video]
     sudo: ["ALL=(ALL) NOPASSWD:ALL"]
     shell: /bin/bash
   network:
     renderers: ['netplan', 'eni', 'sysconfig']
     activators: ['netplan', 'eni', 'network-manager', 'networkd']
   # Automatically discover the best ntp_client
   ntp_client: auto
   # Other config here will be given to the distro class and/or path classes
   paths:
      cloud_dir: /var/lib/cloud/
      templates_dir: /etc/cloud/templates/
   package_mirrors:
     - arches: [i386, amd64]
       failsafe:
         primary: http://archive.ubuntu.com/ubuntu
         security: http://security.ubuntu.com/ubuntu
       search:
         primary:
           - http://%(ec2_region)s.ec2.archive.ubuntu.com/ubuntu/
           - http://%(availability_zone)s.clouds.archive.ubuntu.com/ubuntu/
           - http://%(region)s.clouds.archive.ubuntu.com/ubuntu/
         security: []
     - arches: [arm64, armel, armhf]
       failsafe:
         primary: http://ports.ubuntu.com/ubuntu-ports
         security: http://ports.ubuntu.com/ubuntu-ports
       search:
         primary:
           - http://%(ec2_region)s.ec2.ports.ubuntu.com/ubuntu-ports/
           - http://%(availability_zone)s.clouds.ports.ubuntu.com/ubuntu-ports/
           - http://%(region)s.clouds.ports.ubuntu.com/ubuntu-ports/
         security: []
     - arches: [default]
       failsafe:
         primary: http://ports.ubuntu.com/ubuntu-ports
         security: http://ports.ubuntu.com/ubuntu-ports
   ssh_svcname: ssh
disable_vmware_customization: false
EOF


# cloud init base configs
sudo rm -rf /etc/netplan/*.yaml
sudo rm -rf /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
sudo rm -rf /etc/cloud/cloud.cfg.d/99-installer.cfg

sudo tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg <<EOF
datasource_list: 
    - VMware 
    - OVF 
    - None
EOF

sudo tee /etc/cloud/cloud.cfg.d/90-vmware-guest-customization.cfg <<EOF
datasource:
  VMware:
    allow_raw_data: false
    vmware_cust_file_max_wait: 10
EOF

sudo tee /etc/cloud/cloud.cfg.d/95-disable-network-config.cfg <<EOF
network: {config: disabled}
EOF

# set statip ips
sudo tee /etc/netplan/50-cloud-init.yaml <<EOF
network:
  version: 2
  ethernets:
    nics:
      match:
        name: ens160
      dhcp4: false
      addresses:
        - 192.168.1.62/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 192.168.1.12
        search:
          - labz.io
EOF

# # cloud init cleanup
# sudo cloud-init clean --logs

# disable ipv6
sudo cp -rp /etc/default/grub /etc/default/grub.orig && \
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="\"ipv6.disable=1\""/g" /etc/default/grub && \
sudo sed -i "s/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g" /etc/default/grub && \
sudo update-grub

### All done. ### 
echo '> Packer Template Build -- Complete'


