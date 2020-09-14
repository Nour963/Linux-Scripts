#!/bin/bash
#change hostname machine without restart
echo "testy" > /etc/hostname
sed -i '1i 127.0.1.1 testy' /etc/hosts
hostnamectl set-hostname testy
exec bash
