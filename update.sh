#!/bin/bash

export REPO="https://github.com/caHarkness/openvpn-install.git"

cd ..                   && sleep 1
rm -rf openvpn-install  && sleep 1
git clone "$REPO"       && sleep 1
cd openvpn-install      && sleep 1
echo $(pwd) > .path     && sleep 1
chmod +x *