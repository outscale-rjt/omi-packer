#!/bin/bash
set -e

#### BASIC IMAGE
yum install -y wget qemu-img libgcrypt
cd /tmp
wget -q https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-9.0-20220830.0.x86_64.qcow2
qemu-img convert ./*.qcow2 -O raw /dev/sda
