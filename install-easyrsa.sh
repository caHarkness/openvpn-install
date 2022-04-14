#!/bin/bash

source common.sh

apt-get update
apt-get install openvpn iptables openssl ca-certificates -y

export EASYRSA_DOWNLOAD="https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.5/EasyRSA-nix-3.0.5.tgz"

curl -Lo ./download.tgz "$EASYRSA_DOWNLOAD"

tar xzf ./download.tgz


exit

mv ~/EasyRSA-3.0.5/ /etc/openvpn/
mv /etc/openvpn/EasyRSA-3.0.5/ /etc/openvpn/easy-rsa/
chown -R root:root /etc/openvpn/easy-rsa/
rm -f ~/easyrsa.tgz
cd /etc/openvpn/easy-rsa/
# Create the PKI, set up the CA and the server and client certificates
./easyrsa init-pki
./easyrsa --batch build-ca nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $CLIENT nopass
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
# Move the stuff we need
cp pki/ca.crt pki/private/ca.key pki/issued/server.crt pki/private/server.key pki/crl.pem /etc/openvpn
# CRL is read with each client connection, when OpenVPN is dropped to nobody
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
# Generate key for tls-auth
openvpn --genkey --secret /etc/openvpn/ta.key