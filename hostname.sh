#!/bin/bash
#change hostname machine without restart
echo "testy" > /etc/hostname
#in case where 127.0.1.1 is already set to ubuntu
sed -i 's/ubuntu/testy/g' /etc/hosts 
#in case where 127.0.1.1 is not set
#sed -i '2i 127.0.1.1 testy' /etc/hosts
hostnamectl set-hostname testy
exec bash
