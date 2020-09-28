#!/bin/bash
#activate ens4 interface either for ubuntu 18 or ubuntu 16

VERSION=$(lsb_release -r -s)
apt install ifupdown -qqy
if [[ $VERSION =~ ["^18"] ]]
then
  echo 'auto ens4\niface ens4 inet dhcp' | tee /etc/network/interfaces > /dev/null
  ifup ens4
elif [[ $VERSION =~ ["^16"] ]]
then
  echo 'auto ens4\niface ens4 inet dhcp' | tee /etc/network/interfaces > /dev/null
  /etc/init.d/networking restart
fi
