# Daemon Install Scrypt (update 2022-02-17) v0.1
***********************************************
<a href="https://discord.gg/xfSwnN7J"><img src="https://img.shields.io/discord/904564600354254898.svg?style=flat&label=Discord %3C3%20&color=7289DA%22" alt="Join Community Badge"/></a>





###

## Install script for Daemon Coin on Ubuntu Server 16.04 / 18.04

Use this script on fresh install ubuntu Server 16.04 / 18.04. ``` No other version is currently supported. ``` There are a few things you need to do after the main install is finished.

## First of all you need to create a new user i use pool, and upgrade the system.

Update and upgrade your system.
```
sudo apt update && sudo apt upgrade -y
```
To create your new user and.
```
adduser daemon
```
To add you new user to sudo group
```
adduser daemon sudo
```
###

### Clone the git repo
- > Be sure you are have su in to your pool user before you clone it, else you clone it to root user

```
sudo su daemon
```
### clone the git repo.
```
git clone https://github.com/vaudois/daemon_install_script.git
```
### cd to the installer map.
```
cd daemon_install_script
```
### Now it's time to start the installation.
```
bash install.sh
```
OR

### all in one go in one line.
```
git clone https://github.com/vaudois/daemon_install_script.git && cd daemon_install_script && bash install.sh
```

- > It will take some time for the installation to be finnished and it will do for you.

***********************************

## This script has an interactive beginning and will ask for the following information :

- Server Name (You can enter )(Example)): example.com or your ip of your vps like this 80.41.52.63)
- Set stratum

***********************************

Finish! Remember to 
```
sudo reboot
```

*****************************************************************************

While I did add some server security to the script, it is every server owners responsibility to fully secure their own servers. After the installation you will still need to customize your serverconfig.php file to your liking, add your API keys, and build/add your coins to the control panel.

## 🎁 Support

Donations for continued support of this script are welcomed at:

