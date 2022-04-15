#!/bin/bash

source common.sh

apt remove openvpn --purge


SERVICE_NAME="openvpn-iptables.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"

if [[ -e "$SERVICE_PATH" ]]
then
    systemctl disable --now $SERVICE_NAME
    rm -rf "$SERVICE_PATH"
fi

OPENVPN_PATH="/etc/openvpn"

if [[ -e "$OPENVPN_PATH" ]]
then
    rm -rf "$OPENVPN_PATH"
    echo "Removed $OPENVPN_PATH"
fi

CONF_NAME="30-openvpn-forward.conf"
CONF_PATH="/etc/sysctl.d/$CONF_NAME"

if [[ -e "$CONF_PATH" ]]
then
    rm -rf "$CONF_PATH"
    echo "Removed $CONF_PATH"
fi