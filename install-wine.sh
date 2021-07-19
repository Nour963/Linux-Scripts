#Ubuntu 18.04
#!/bin/bash
dpkg --add-architecture i386
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
add-apt-repository ppa:cybermax-dexter/sdl2-backport
apt update -qq
apt install --install-recommends winehq-stable -yqq
apt-get update && apt-get install wine32 -yqq
#run this WITHOUT X SERVER
runuser -l "ubuntu" -c "/usr/bin/winecfg || true"
#copy outside files
#these 3 reg files (user, user-def, system) are created inside /home/ubuntu/.wine when winecfg is run with ubuntu user with X Server enabled
cp *.reg /home/ubuntu/.wine
#change old hostname on old system.reg file
sed -i "s/test/$(hostname)/g" /home/ubuntu/.wine/system.reg
chown -R ubuntu:ubuntu /home/ubuntu
#download microsip
wget https://www.microsip.org/download/MicroSIP-3.20.6.zip 1>/dev/null
mkdir /home/ubuntu/microsip
apt-get install unzip -yqq
unzip Micro*.zip -d /home/ubuntu/microsip
rm Micro*.zip
chown -R ubuntu:ubuntu /home/ubuntu/microsip
#how to run microsip with wine, WITH X SERVER enabled
cat > /usr/local/bin/microsip <<'EOF'
#!/bin/bash
cd ~/microsip
DISPLAY=:10.0
DISPLAY=:10.0 wine microsip.exe &>/dev/null
EOF
chmod +x /usr/local/bin/microsip

======================================================================
#Kali 2012.2
#!/bin/bash
#install wine to run microsip.exe
apt-get update
apt-get install software-properties-common wget -y
wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key | sudo apt-key add -
add-apt-repository 'deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./'
apt-get update -qq
dpkg --add-architecture i386 && apt-get update && apt-get install wine32 -yqq
apt-get install libsm6:i386 -yqq
apt-get install --install-recommends winehq-stable -yqq
#run without X server
runuser -l "kali" -c "/usr/bin/winecfg || true"
#from gitlab repo
cp pent/*.reg /home/kali/.wine
sed -i "s/test-2/$(hostname)/g" /home/kali/.wine/system.reg
chown -R kali:kali /home/kali

#download microsip
wget https://www.microsip.org/download/MicroSIP-3.20.6.zip 1>/dev/null
mkdir /home/kali/microsip
unzip Micro*.zip -d /home/kali/microsip
apt-get install unzip -yqq
rm Micro*.zip
#how to run microsip with wine
cat > /usr/local/bin/microsip <<'EOF'
#!/bin/bash
cd ~/microsip
DISPLAY=:10.0
DISPLAY=:10.0 wine microsip.exe &>/dev/null
EOF
chmod +x /usr/local/bin/microsip
