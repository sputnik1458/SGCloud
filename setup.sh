#!/usr/bin/env bash

CONFIG_DIR=".sgcloud"
DIR=$PWD
ROOT_DIR="SGCloud"
CONFIG=("IP" "PORT" "RUSER" "INT")

echo "Before setting up SGCloud, make sure that you have installed SSH on your server and configured port forwarding on its router."

read -p "Enter the IP or hostname of your remote server: " IP
read -p "Enter the listening port of your remote server[22]: " PORT
read -p "Enter the user you wish to login as: " RUSER
read -p 'Enter the interval (in seconds) to sync the directories[30]: ' INT
read -p "Would you like SGCloud to start at boot?[Y/n]: " C

PORT=${PORT:-22}
INT=${INT:-30}
C=${C:-Y}

function add_dir {

    if [ ! -d "$1" ]; then
        mkdir "$1"
        echo "Created $1 in home directory."
    fi
}

cd ~

add_dir $CONFIG_DIR
add_dir $CONFIG_DIR/scripts
add_dir .ssh

function add_config {
    
    echo ${CONFIG[$1]}=$2 >> ~/$CONFIG_DIR/config

}

chmod 700 .ssh && cd .ssh

echo "Looking for SSH keys..."

if [ ! -e id_rsa ]; then
    echo "SSH keys not found. Creating..."
    ssh-keygen -t rsa
    echo "SSH keys created"
    ssh-copy-id -p 31458 $RUSER@$IP
    echo "SSH keys sent to remote server"
else
    echo "SSH keys found"
fi



echo "Testing SSH connection..."
{
    ssh -p $PORT $RUSER@$IP "exit" && echo "SSH connection successful."
} || {
    echo "Error: Failed to establish SSH connection."
    exit
}


add_config 0 $IP
add_config 1 $PORT
add_config 2 $RUSER
add_config 3 $INT

cd $DIR

cp sgcloud.sh ~/$CONFIG_DIR/scripts
cp sync.sh ~/$CONFIG_DIR/scripts
cp setup.sh ~/$CONFIG_DIR/scripts

cd ~

{
    git clone ssh://$RUSER@$IP:$PORT/home/$RUSER/$ROOT_DIR
} || {
    ssh -p $PORT $RUSER@$IP "mkdir SGCloud && cd SGCloud && git init --bare && git config --bool core.bare true && exit"
}


add_dir $ROOT_DIR


if [ ! "$(ls -A ~/$ROOT_DIR)" ]; then    
    cd ~/$ROOT_DIR
    git init
    touch init.txt
    git pull origin master
    git add .
    git commit -a --allow-empty-message -m ''
    git remote add origin ssh://$RUSER@$IP:$PORT/home/$RUSER/$ROOT_DIR
    git push origin master
fi

echo "Git sucessfully configured"

if [ "$C" -eq "Y" ] || [ "$C" -eq "y" ]; then
    crontab -l > tmpcron
    echo "@reboot /home/$USER/$CONFIG_DIR/scripts/sync.sh"
    crontab tmpcron
    rm tmpcron
fi
