#!/bin/bash
#rename ens3 interface to eth0 on a cloud instance
ifdown ens3
sed -i 's/ens3/eth0/g' /etc/udev/rules.d/70-persistent-net.rules
sed -i 's/ens3/eth0/g' /etc/network/interfaces.d/50-cloud-init.cfg
sed -i 's/ens3/eth0/g' /etc/network/interfaces
ip link set ens3 name eth0
ifup eth0
