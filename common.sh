#!/bin/bash

source config.sh

go_back () {
    cd "$INSTALL_DIRECTORY"
}

if [[ "$EUID" -ne 0 ]]
then
    echo "These scripts must be run as root."
    exit
fi

go_back