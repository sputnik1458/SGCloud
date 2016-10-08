#!/bin/bash

CONFIG_DIR=".sgcloud"

if [ ! -d ~/$CONFIG_DIR ]; then
    ./setup.sh
fi

#cd ~/$CONFIG_DIR/scripts
#./pull.sh </dev/null &>/dev/null &
#echo "Started remote sync"
#./push.sh </dev/null &>/dev/null &
#echo done
./sync.sh </dev/null &>/dev/null &
echo "Sync started"
