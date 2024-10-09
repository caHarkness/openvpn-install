#!/bin/bash

# https://stackoverflow.com/a/1482133
export INSTALL_DIR="$(dirname -- "$(readlink -f -- "$0";)";)"

export PROTOCOL="tcp"

export PORT="1194"

export DNS_SERVER_1="8.8.8.8"

export DNS_SERVER_2="8.8.4.4"

# https://askubuntu.com/a/95911
export PUBLIC_IP="$(curl https://ipinfo.io/ip)"
