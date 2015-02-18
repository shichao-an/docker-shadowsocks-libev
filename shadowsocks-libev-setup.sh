#!/usr/bin/env bash
# Setup shadowsocks-libev in docker on Ubuntu 14.04 with UFW
# Run as root
# Update /etc/shadowsocks-libev/config.json as your need

set -e
apt-get update
# Install iptables-persistent
apt-get install -y iptables-persistent

# Enable UFW forwarding and open TCP port 2375
ufw enable
sed -i 's/\(DEFAULT_FORWARD_POLICY\)="DROP"/\1="ACCEPT"/g' /etc/default/ufw
# allow more ports according to your scenario
ufw allow 22/tcp
ufw allow 2375/tcp
ufw allow 8388/tcp
ufw reload

# Save iptables ruls
service iptables-persistent save

# Install docker and dependencies
[ -e /usr/lib/apt/methods/https ] || {
    apt-get update
    apt-get install apt-transport-https
}

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
curl -sSL https://get.docker.com/ubuntu/ | sh


mkdir /etc/shadowsocks-libev
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server":"0.0.0.0",
    "server_port":8388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"your password",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false,
    "workers": 1
}
EOF
vim /etc/shadowsocks-libev/config.json
# Pull pre-built docker images
docker pull shichaoan/shadowsocks-libev
docker run --restart=always -d -p 8388:8388 --name shadowsocks-libev \
    -v /etc/shadowsocks-libev:/etc/shadowsocks-libev \
    shichaoan/shadowsocks-libev -c /etc/shadowsocks-libev/config.json
