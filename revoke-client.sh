#!/bin/bash

source common.sh

if [[ "$1" == "" ]]
then
    echo "A client name must be specified."
    exit
fi

cd EasyRSA
./easyrsa --batch revoke $1
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl

rm -f pki/reqs/$1.req
rm -f pki/private/$1.key
rm -f pki/issued/$1.crt

rm -f /etc/openvpn/crl.pem
cp -vfar pki/crl.pem /etc/openvpn/crl.pem

chown nobody:nogroup /etc/openvpn/crl.pem
