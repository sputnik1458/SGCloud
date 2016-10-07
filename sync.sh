#!/bin/bash


cd ~/SGCloud

while [ true ]; do
    git pull origin master
    git add .
    git commit -a --allow-empty-message -m ''
    git push origin master
    sleep 30
done
