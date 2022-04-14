#!/bin/bash

cd ..
rm -rf openvpn-install
git clone https://github.com/caHarkness/openvpn-install.git
cd openvpn-install
echo $(pwd) > .path
chmod +x *