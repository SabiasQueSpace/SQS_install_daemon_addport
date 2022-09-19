# Install Daemon COIN and addport (update 2022-09-19) v0.1
***********************************************
<a href="https://discord.gg/xfSwnN7J"><img src="https://img.shields.io/discord/904564600354254898.svg?style=flat&label=Discord %3C3%20&color=7289DA%22" alt="Join Community Badge"/></a>





###

## Install script for Daemon Coin and addport on Ubuntu Server 16.04 / 18.04

Use this script on fresh install ubuntu Server 16.04 / 18.04. ``` No other version is currently supported. ``` There are a few things you need to do after the main install is finished.

## First of all you need to create a new user i use pool, and upgrade the system.

Update and upgrade your system.
```
sudo apt update && sudo apt upgrade -y
```
###

### Clone the git repo
- > Be sure you are have su in to your pool user before you clone it, else you clone it to root user

```
sudo su user
```
### clone the git repo.
```
git clone https://github.com/vaudois/install_daemon_addport.git
```
### cd to the installer map.
```
cd install_daemon_addport
```
### Now it's time to start the installation.
```
bash install.sh
```
OR

### all in one go in one line.
```
git clone https://github.com/vaudois/install_daemon_addport.git && cd install_daemon_addport && bash install.sh
```

- > It will take some time for the installation to be finnished and it will do for you.

***********************************

## This script has an interactive beginning and will ask for the following information :

- Path to stratum file (You can enter )(Example)): /var/stratum)
- Set stratum

***********************************

Finish! Remember to 
```
how to use 

$ daemonbuilder
$ addport

*****************************************************************************

## 🎁 Support

Donations for continued support of this script are welcomed at:

