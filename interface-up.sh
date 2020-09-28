#!/bin/bash
#activate ens4 interface either for ubuntu 18 or ubuntu 16

VERSION=$(lsb_release -r -s)
if [[ $VERSION =~ ["^18"] ]]
then
  echo 'auto ens4\niface ens4 inet dhcp' | sudo tee /etc/network/interfaces > /dev/null
  apt install ifupdown -qqy
  ifup ens4
elif [[ $VERSION =~ ["^16"] ]]
then
  echo "
  auto ens4
  iface ens4 inet dhcp" >> /etc/network/interfaces.d/50-cloud-init.cfg
  /etc/init.d/networking restart
fi
