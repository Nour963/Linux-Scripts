#!/bin/bash
#Make /etc/resolv.conf permanent
rm /etc/resolv.conf
apt-get install resolvconf -y
echo"
nameserver 192.168.2.82
search ims.mnc001.mcc001.3gppnetwork.org" > /etc/resolvconf/resolv.conf.d/base
ln -sf /etc/resolvconf/resolv.conf.d/base /etc/resolv.conf

