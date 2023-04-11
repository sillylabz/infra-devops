#!/usr/bin/bash

echo '> Starting Server config actions...'

# Prepares a Rocky linux Server guest operating system.
echo "Updating the system..."
sudo dnf -y update

echo "Installing packages"
sudo dnf -y install open-vm-tools curl unzip perl perl-File-Temp python3

# # see https://bugs.launchpad.net/cloud-init/+bug/1712680
# # and https://kb.vmware.com/s/article/71264
# # Virtual Machine customized with cloud-init is set to DHCP after reboot
# echo "manual_cache_clean: True " > /etc/cloud/cloud.cfg.d/99-manual.cfg

# echo "Disable NetworkManager-wait-online.service"
# sudo systemctl disable NetworkManager-wait-online.service

# cleanup current SSH keys so templated VMs get fresh key
# sudo rm -f /etc/ssh/ssh_host_*

# Avoid ~200 meg firmware package we don't need
# this cannot be done in the KS file so we do it here
echo "Removing extra firmware packages"
sudo dnf -y remove linux-firmware
sudo dnf -y autoremove

echo "Remove previous kernels that preserved for rollbacks"
sudo dnf -y remove -y $(dnf repoquery --installonly --latest-limit=-1 -q)
sudo dnf -y clean all  --enablerepo=\*;

echo "truncate any logs that have built up during the install"
sudo find /var/log -type f -exec truncate --size=0 {} \;

echo "remove the install log"
sudo rm -f /root/anaconda-ks.cfg /root/original-ks.cfg

echo "remove the contents of /tmp and /var/tmp"
sudo rm -rf /tmp/* /var/tmp/*

echo "Force a new random seed to be generated"
sudo rm -f /var/lib/systemd/random-seed

echo "Wipe netplan machine-id (DUID) so machines get unique ID generated on boot"
sudo truncate -s 0 /etc/machine-id

echo "Clear the history so our install commands aren't there"
sudo rm -f /root/.wget-hsts
export HISTSIZE=0

sudo tee /etc/redhat-release << EOF
CentOS
EOF

# # disable ipv6
# sudo cp -rp /etc/default/grub /etc/default/grub.orig && \
# sudo tee -a /etc/default/grub << EOF
# GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX ipv6.disable=1"
# EOF

# sudo grub2-mkconfig -o /boot/grub2/grub.cfg

### All done. ### 
echo '> Packer Template Build -- Complete'


