#!/usr/bin/env bash

ROOT_DIR="SGCloud" 
CONFIG_DIR=".sgcloud"
DIR=$PWD
CONFIG=("IP" "PORT" "USER")

echo "Before setting up SGCloud, make sure that you have installed SSH on your server and configured port forwarding on its router."

read -p "Enter the IP or hostname of your remote server: " IP
read -p "Enter the listening port of your remote server: " PORT
read -p "Enter the user you wish to login as: " USER

echo "Testing SSH connection..."
{
    ssh -p $PORT $USER@$IP "exit" && echo "SSH connection successful."
} || {
    echo "Error: Failed to establish SSH connection."
    exit
}

cd ~

function add_dir {

    if [ ! -d "$1" ]; then
        mkdir "$1"
        echo "Created $1 in home directory."
    fi
}

function add_config {
    
    echo ${CONFIG[$1]}=$2 >> ~/.sshcloud/config

}

add_dir $CONFIG_DIR
add_dir $CONFIG_DIR/scripts

add_config 0 $IP
add_config 1 $PORT
add_config 2 $USER

cd $DIR

cp sgcloud.sh ~/$CONFIG_DIR/scripts
cp sync.sh ~/$CONFIG_DIR/scripts

cd ~

{
    git clone ssh://$USER@$IP:$PORT/home/$USER/$ROOT_DIR
} || {
    ssh -p $PORT $USER@$IP "mkdir SGCloud && cd SGCloud && git init --bare && git config --bool core.bare true && exit"
}


add_dir $ROOT_DIR


if [ ! "$(ls -A ~/$ROOT_DIR)" ]; then    
    cd ~/$ROOT_DIR
    git init
    touch init.txt
    git pull origin master
    git add .
    git commit -a --allow-empty-message -m ''
    git remote add origin ssh://$USER@$IP:$PORT/home/$USER/$ROOT_DIR
    git push origin master
fi



echo "Git sucessfully configured"

