#!/bin/bash
clear
this=`curl -s http://api.ipify.org`
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
printf "Script for vmess through your proxy (nginx), run this on the middleman computer that has access to internet\n"
printf "${GREEN}This would be the port that you configure your router with,\nIf the 8090 is open on your ISP, leave it to default, otherwise, change it${NC}\n"
read -p "Enter your desired port [default: 8090]: " thisport
thisport=${thisport:-8090}
read -p "Enter your VMESS link: " vmess
vmess=${vmess:8}
vmess1=`echo $vmess | base64 --decode>v.json`
ip=$(jq -r  '.add' v.json)
port=$(jq -r  '.port' v.json)
ps=$(jq -r '.ps' v.json)
id=$(jq -r '.id' v.json)
echo $ip
echo $port
apt-get update
apt-get install nginx
echo "stream {" >> /etc/nginx/nginx.conf
echo "    upstream external {" >> /etc/nginx/nginx.conf
echo "        server ${ip}:${port};  }" >> /etc/nginx/nginx.conf
echo "    server {" >> /etc/nginx/nginx.conf
echo "        listen     ${thisport};" >> /etc/nginx/nginx.conf
echo "        proxy_pass external ; }" >> /etc/nginx/nginx.conf
echo "}" >> /etc/nginx/nginx.conf
systemctl restart nginx
printf "${GREEN}SETUP IS COMPLETE \n\nImport this link to your VMESS/V2ray client:\n"
newlink=$(echo "{'v': '2','ps': '${ps}','add': '${this}','port': ${thisport},'id': '${id}','aid': 0,'net': 'ws','type': 'none','host': '','path': '/','tls': 'none'}")
shopt -s extglob
newlink=$(echo $newlink | sed "s/'/\"/g")
newlink=$(echo $newlink | sed 's/ //g')
newlink=$(echo "${newlink}" | base64)
echo $newlink >1.txt
sed -i '1s/^/vmess:\/\//' 1.txt
cat 1.txt | sed 's/ //g'
printf "${NC}Follow me on Twitter:\nhttps://twitter.com/hey_itsmyturn\nGoodbye\n\n\n"
