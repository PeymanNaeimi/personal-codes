#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
clear
this=`curl -s http://api.ipify.org`
echo "Your internet IP is:"
echo $this
localip=$(hostname -I)
localip=$(echo $localip | cut -d ' ' -f 1)
echo "Your network IP address is:"
echo $localip
echo "MAKE SURE YOU SET ${localip} as DMZ on your router/modem"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
printf "\nBy: Aleph - https://twitter.com/hey_itsmyturn\n"
printf "Script for VLESS through your proxy (nginx), run this on the middleman computer that has access to internet\n"
printf "${GREEN}This would be the port that you configure your router with,\nIf the 443 is open on your ISP, leave it to default, otherwise, change it${NC}\n"

read -p "Enter your desired port [default: 443]: " thisport
thisport=${thisport:-443}
read -p "Enter your VLESS link: " vless
apt update
arr=(${vless//[@?]/ })
ipport=${arr[1]}
ip=$(echo $ipport | cut -d : -f 1)
port=$(echo $ipport | cut -d : -f 2)
uuid=$(echo $vless | cut -d / -f 3)
uuid=$(echo $uuid | cut -d @ -f 1)
name=$(echo $vless | cut -d '#' -f 2)
apt-get install -y nginx
rm -rf /etc/nginx/nginx.conf
dpkg --force-confmiss -i /var/cache/apt/archives/nginx-common_*.debano /etc/nginx/nginx.conf
echo "stream {" >> /etc/nginx/nginx.conf
echo "    upstream external {" >> /etc/nginx/nginx.conf
echo "        server ${ip}:${port};  }" >> /etc/nginx/nginx.conf
echo "    server {" >> /etc/nginx/nginx.conf
echo "        listen     ${thisport};" >> /etc/nginx/nginx.conf
echo "        proxy_pass external ; }" >> /etc/nginx/nginx.conf
echo "}" >> /etc/nginx/nginx.conf
systemctl restart nginx
newlink=$(echo "vless://${uuid}@${this}:${thisport}?type=ws&security=none&path=/#${name}")
echo "Setup is complete"
echo "You may now import this link to your vless client:"
echo $newlink
