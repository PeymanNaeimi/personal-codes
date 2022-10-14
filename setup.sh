#!/bin/bash
sudo apt update
sudo apt install -y unzip python3-pip
sudo apt install ipset -y  && ipset create countries hash:net && mkdir /root/ipset && cd /root/ipset && wget https://raw.githubusercontent.com/therealaleph/personal-codes/main/ban.sh && chmod +x /root/ipset/ban.sh && bash /root/ipset/ban.sh && touch /root/iptables.sh && chmod +x /root/iptables.sh && echo -e "iptables -F\niptables -X\niptables -P INPUT ACCEPT\niptables -P FORWARD ACCEPT\niptables -P OUTPUT ACCEPT\niptables -I INPUT   -m set --match-set countries src -j DROP\niptables -I FORWARD -m set --match-set countries src -j DROP\n" >> /root/iptables.sh && bash /root/iptables.sh
ufw reload
ufw allow 1:65535/tcp && ufw allow 1:65535/udp && ufw deny out from any to 10.0.0.0/8 && ufw deny out from any to 172.16.0.0/12 && ufw deny out from any to 192.168.0.0/16 && ufw deny out from any to 100.64.0.0/10 &&  ufw deny out from any to 198.18.0.0/15 && ufw deny out from any to 169.254.0.0/16
ufw enable
wget github.com/v2fly/v2ray-core/releases/download/v5.1.0/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
rm -rf v2ray-linux-64.zip
cd v2ray
rm -rf config.json
wget https://raw.githubusercontent.com/therealaleph/personal-codes/main/vmessgen19.py
mv vmessgen19.py uidgen.py
python3 uidgen.py
nohup ./v2ray run &
