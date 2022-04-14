#!/bin/bash

export REPO="https://github.com/caHarkness/openvpn-install.git"

cd ~; rm -rf openvpn-install; git clone "$REPO"; cd openvpn-install; echo $(pwd) > .path; chmod +x *.sh