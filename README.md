# SGCloud
An automated cloud storage system using SSH and git

## Usage
After cloning the repository, run the `sgcloud.sh` script. That's it! Your local device will now "push" and "pull" modifications to and from the remote server every 30 seconds. For increased security, disable Password Authentication for SSH and use [Public Key Authentication](https://help.ubuntu.com/community/SSH/OpenSSH/Keys). To start syncing at boot, add `sgcloud.sh` to your list of autostart programs. 
