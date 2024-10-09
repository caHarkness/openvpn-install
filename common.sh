#!/bin/bash

source config.sh

go_back () {
    cd "${INSTALL_DIR}"
}

prompt_user () {
    export DO_SCRIPT=0
    clear

    echo "WARNING:"
    echo "This script is about to: $1"
    echo ""

    read -p "Type 'YES' if you wish to continue: " PROMPT
    if [[ $PROMPT == "YES" ]]
    then
        echo "OK."
        export DO_SCRIPT=1
    else
        echo "Aborted."
    fi

    echo ""
    sleep 1
}

if [[ "$EUID" -ne 0 ]]
then
    echo "These scripts must be run as root."
    exit
fi

go_back
