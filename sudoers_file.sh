#!/bin/bash
#automate writing to sudoers file
NF_LIST="nrf amf pcrf udr udm ausf upf sgwu smf sgwc mme hss"
VAR=(.service " ") #example: 'systemctl start sshd.service' AND 'systemctl start sshd'
AC="start restart stop status"
echo -n "ubuntu ALL=(ALL) NOPASSWD: /sbin/ip, /bin/kill, /usr/bin/pkill, /usr/sbin/tcpdump, /bin/netstat, " > /etc/sudoers.d/90-cloud-init-users
for NF in ${NF_LIST}; do
    for i in 0 1; do
        for ac in ${AC}; do
           echo -n "/bin/systemctl ${ac} open5gs-${NF}d${VAR[i]}, " >> /etc/sudoers.d/90-cloud-init-users
           if [[ ${NF} == 'hss' ]]
           then
             echo -n "/bin/systemctl ${ac} ${NF}${VAR[i]}, " >> /etc/sudoers.d/90-cloud-init-users
           fi 
        done
    done
done
sed -i 's/\(.*\),/\1 /' /etc/sudoers.d/90-cloud-init-users
echo "" >> /etc/sudoers.d/90-cloud-init-users
