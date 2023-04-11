#!/usr/bin/bash

echo '> Starting Server config actions...'

# Prepares a Rocky linux Server guest operating system.
echo "Updating the system..."
sudo yum -y update

echo "Installing packages"
sudo yum -y install wget curl unzip

cd /tmp
wget https://packages.vmware.com/tools/legacykeys/VMWARE-PACKAGING-GPG-DSA-KEY.pub
wget https://packages.vmware.com/tools/legacykeys/VMWARE-PACKAGING-GPG-RSA-KEY.pub
sudo rpm --import VMWARE-PACKAGING-GPG-DSA-KEY.pub
sudo rpm --import VMWARE-PACKAGING-GPG-RSA-KEY.pub

sudo tee /etc/yum.repos.d/vmware-tools.repo << EOF
[vmware-tools]
name = VMware Tools
baseurl = https://packages.vmware.com/packages/rhel7/x86_64/
enabled = 1
gpgcheck = 1
EOF

sudo yum install -y open-vm-tools-deploypkg perl
sudo systemctl restart vmtoolsd


sudo tee -a /etc/sysctl.d/70-ipv6.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF
sudo sysctl --load /etc/sysctl.d/70-ipv6.conf
sudo nmcli connection modify ens192 ipv6.method ignore

# cleanup current SSH keys so templated VMs get fresh key
sudo rm -f /etc/ssh/ssh_host_*

# Avoid ~200 meg firmware package we don't need
# this cannot be done in the KS file so we do it here
echo "Removing extra firmware packages"
sudo yum -y remove linux-firmware
sudo yum -y autoremove

echo "Remove previous kernels that preserved for rollbacks"
sudo yum -y remove -y $(yum repoquery --installonly --latest-limit=-1 -q)
sudo yum -y clean all  --enablerepo=\*;

echo "truncate any logs that have built up during the install"
sudo find /var/log -type f -exec truncate --size=0 {} \;

echo "remove the contents of /tmp and /var/tmp"
sudo rm -rf /tmp/* /var/tmp/*

echo "Force a new random seed to be generated"
sudo rm -f /var/lib/systemd/random-seed

echo "Wipe netplan machine-id (DUID) so machines get unique ID generated on boot"
sudo truncate -s 0 /etc/machine-id

echo "Clear the history so our install commands aren't there"
sudo rm -f /root/.wget-hsts
export HISTSIZE=0


### All done. ### 
echo '> Packer Template Build -- Complete'


