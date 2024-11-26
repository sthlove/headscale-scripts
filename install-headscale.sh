#!/bin/sh
clear
#Updates the System
apt update && apt upgrade -y

#Installs requierd apt
apt install wget nano -y

#Installs Headscale
wget --output-document=headscale.deb   https://github.com/juanfont/headscale/releases/download/v0.23.0/headscale_0.23.0_linux_amd64.deb
sudo dpkg --install headscale.deb

#Asks basic Configuration for headscale
publicip=$(curl ipinfo.io/ip)
echo "What is the server IP or DNS? Default: Your public IP ($publicip)"
read headscaleip
headscaleip=${headscaleip:-$publicip}
sed -i "s!server_url: http://.*:8081!server_url: http://$headscaleip:8081!" /etc/headscale/config.yaml
sed -i "s!listen_addr: 127.0.0.1:8081!listen_addr: 0.0.0.0:8081!" /etc/headscale/config.yaml
sed -i '68d' /etc/headscale/config.yaml

#Enables and Starts the headscale server
sudo systemctl enable headscale
sudo systemctl start headscale

#Removes the headscale.deb
rm -f headscale.deb
