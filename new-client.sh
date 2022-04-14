#!/bin/bash

source common.sh

if [[ "$1" == "" ]]
then
    echo "A client name must be specified."
    exit
fi

if [[ ! -e "clients" ]]
then
    mkdir "clients"
fi

cd easyrsa
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $1 nopass
go_back


DATA=$(<template/client.txt)
DATA=${DATA//__REMOTE_ADDRESS__/$PUBLIC_IP}

echo $DATA > clients/$1.ovpn

echo "<ca>" >> clients/$1.ovpn
cat easyrsa/pki/ca.crt >> clients/$1.ovpn
echo "</ca>" >> clients/$1.ovpn

echo "<cert>" >> clients/$1.ovpn
sed -ne "/BEGIN CERTIFICATE/,$ p" easyrsa/pki/issued/$1.crt >> clients/$1.ovpn
echo "</cert>" >> clients/$1.ovpn

echo "<key>" >> clients/$1.ovpn
cat easyrsa/pki/private/$1.key >> clients/$1.ovpn
echo "</key>" >> clients/$1.ovpn

echo "<tls-auth>" >> clients/$1.ovpn
sed -ne "/BEGIN OpenVPN Static key/,$ p" /etc/openvpn/ta.key >> clients/$1.ovpn
echo "</tls-auth>" >> clients/$1.ovpn

# For making this client not redirect traffic
echo "pull-filter ignore \"redirect-gateway def1 bypass-dhcp\"" >> clients/$1.ovpn

go_back