#!/bin/bash

source common.sh

apt-get update
apt-get install openvpn iptables openssl ca-certificates -y

export EASYRSA_DOWNLOAD="https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.5/EasyRSA-nix-3.0.5.tgz"
export CLIENT="clientname"

curl -Lo ./download.tgz "$EASYRSA_DOWNLOAD"

tar xzf ./download.tgz
rm -f download.tgz

mv EasyRSA-* easyrsa
chown -R root:root easyrsa

cd easyrsa

./easyrsa init-pki
./easyrsa --batch build-ca nopass

EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $CLIENT nopass
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl

cp pki/ca.crt pki/private/ca.key pki/issued/server.crt pki/private/server.key pki/crl.pem /etc/openvpn
chown nobody:nogroup /etc/openvpn/crl.pem

openvpn --genkey --secret /etc/openvpn/ta.key