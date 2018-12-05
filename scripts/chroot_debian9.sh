#!/bin/bash

#### BASIC IMAGE
yum install -y wget
cd /tmp
wget -q https://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.raw
wget -q https://cdimage.debian.org/cdimage/openstack/current/MD5SUMS
if [[ $(md5sum -c MD5SUMS 2>&1 | grep -c OK) < 1 ]]; then exit 1; fi
mv *.raw debian9.raw
dd if=./debian9.raw of=/dev/sda bs=1G status=progress conv=sparse
mount /dev/sda1 /mnt

#### CHROOT FIXES
cp /etc/resolv.conf /mnt/etc/resolv.conf
mount -o bind /dev /mnt/dev
mount -o bind /proc /mnt/proc
mount -o bind /sys /mnt/sys

#### UPDATES
chroot /mnt/ apt update -y
chroot /mnt/ apt upgrade -y
chroot /mnt/ apt clean

#### OUTSCALE PACKAGES
wget https://osu.eu-west-2.outscale.com/outscale-official-packages/udev/osc-udev-rules_20160516_amd64.deb -P /mnt/tmp
chroot /mnt/ dpkg -i /tmp/osc-udev-rules_20160516_amd64.deb
wget https://osu.eu-west-2.outscale.com/outscale-official-packages/fni/osc-fni-1.0.0-x86_64.deb -P /mnt/tmp
chroot /mnt/ dpkg -i /tmp/osc-fni-1.0.0-x86_64.deb
yes | cp -i /tmp/cloud.cfg /mnt/etc/cloud/cloud.cfg
yes | cp -i /tmp/sshd_config /mnt/etc/ssh/sshd_config
rm -f /mnt/etc/cloud/cloud.cfg.d/90_dpkg.cfg

#### CLEANUP
rm -rf /mnt/var/cache/apt
rm -rf /mnt/root/.ssh
rm -rf /mnt/root/.bash_history
rm -rf /mnt/home/debian/.ssh
rm -rf /mnt/home/debian/.bash_history
rm -rf /mnt/tmp/*
rm -rf /mnt/var/lib/dhcp/
rm -rf /mnt/var/tmp/*
rm -rf /mnt/var/log/*
rm -rf /mnt/var/lib/cloud/*
