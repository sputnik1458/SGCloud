#!/bin/bash

CONFIG_DIR=".sgcloud"

if [ ! -d ~/$CONFIG_DIR ]; then
    ./setup.sh
fi

./sync.sh </dev/null &>/dev/null &
echo "Sync started"
