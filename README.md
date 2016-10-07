# SSHCloud
An automated cloud storage system using SSH and rsync

## Usage
After cloning the repository, run the `sshcloud.sh` script. That's it! Your local device will now "push" changes to the remote server every 30 seconds, and "pull" changes from the remote server every 5 minutes. For increased security, disable Password Authentication for SSH and use [Public Key Authentication](https://help.ubuntu.com/community/SSH/OpenSSH/Keys). To start syncing at boot, add `sshcloud.sh` to your list of autostart programs. 
