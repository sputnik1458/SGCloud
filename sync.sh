#!/bin/bash

source ~/.sgcloud/config
cd ~/SGCloud

while [ true ]; do
    git pull origin master
    git add .
    git commit -a --allow-empty-message -m ''
    git push origin master
    sleep $INT
done
