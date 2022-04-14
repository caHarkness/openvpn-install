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

echo $DATA > client/$1.ovpn

echo "<ca>" >> client/$1.ovpn
cat easyrsa/pki/ca.crt >> client/$1.ovpn
echo "</ca>" >> client/$1.ovpn

echo "<cert>" >> client/$1.ovpn
sed -ne "/BEGIN CERTIFICATE/,$ p" easyrsa/pki/issued/$1.crt >> client/$1.ovpn
echo "</cert>" >> client/$1.ovpn

echo "<key>" >> client/$1.ovpn
cat easyrsa/pki/private/$1.key >> client/$1.ovpn
echo "</key>" >> client/$1.ovpn

echo "<tls-auth>" >> client/$1.ovpn
sed -ne "/BEGIN OpenVPN Static key/,$ p" /etc/openvpn/ta.key >> client/$1.ovpn
echo "</tls-auth>" >> client/$1.ovpn

# For making this client not redirect traffic
echo "pull-filter ignore \"redirect-gateway def1 bypass-dhcp\"" >> client/$1.ovpn

go_back