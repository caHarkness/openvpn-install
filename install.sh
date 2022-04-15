#!/bin/bash

source common.sh

apt-get update
apt-get install openvpn iptables openssl ca-certificates -y

# Download and install EasyRSA
export EASYRSA_DOWNLOAD="https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.5/EasyRSA-nix-3.0.5.tgz"

curl -Lo ./download.tgz "$EASYRSA_DOWNLOAD"

tar xzf ./download.tgz
rm -f download.tgz

mv EasyRSA-* easyrsa
chown -R root:root easyrsa

cd easyrsa

./easyrsa init-pki
./easyrsa --batch build-ca nopass

EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
# EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full default nopass

go_back
./new-client.sh default
cd easyrsa

EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl

cp -f \
    pki/ca.crt \
    pki/private/ca.key \
    pki/issued/server.crt \
    pki/private/server.key \
    pki/crl.pem \
    /etc/openvpn

go_back
chown nobody:nogroup /etc/openvpn/crl.pem
openvpn --genkey --secret /etc/openvpn/ta.key
cp template/dh.pem /etc/openvpn/dh.pem

# Enable port forwarding
if [[ -d "/etc/sysctl.d" ]]
then
    cp template/30-openvpn-forward.conf /etc/sysctl.d
    echo 1 > /proc/sys/net/ipv4/ip_forward
else
    echo "WARNING: /etc/sysctl.d is not a directory, is this a Debian distribution?"
    exit
fi

# Install port forwarding service
if [[ -d "/etc/systemd/system" ]]
then
    echo "Installing service..."

    cp template/openvpn-iptables.service /etc/systemd/system

    sed -i "s/__PUBLIC_IP__/$PUBLIC_IP/g" /etc/systemd/system/openvpn-iptables.service

    systemctl enable --now openvpn-iptables.service
    systemctl restart openvpn@server.service

    echo "Done installing service."
else
    echo "WARNING: /etc/systemd/system is not a directory, is this a Debian distribution?"
    exit
fi