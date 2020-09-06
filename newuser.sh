#!/bin/sh 
#create a user with a password and home directory
useradd kube
echo kube:helloo | chpasswd
mkhomedir_helper kube
