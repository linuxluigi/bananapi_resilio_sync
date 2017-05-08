#!/bin/bash

# update the system
sudo apt-get update
sudo apt-get -y dist-upgrade

# user settings
sudo dpkg-reconfigure tzdata

# set hostname
read -p "Enter new hostname [bpi-iot-ros]: " hostname
hostname=${hostname:-bpi-iot-ros}

sudo sed -i "s/127.0.0.1   localhost bpi-iot-ros/127.0.0.1   localhost $hostname/g" /etc/hosts
sudo sed -i "s/::1         localhost bpi-iot-ros ip6-localhost ip6-loopback/::1         localhost $hostname ip6-localhost ip6-loopback/g" /etc/hosts

sudo sh -c "echo $hostname > /etc/hostname"
sudo hostname -F /etc/hostname

# secure
# auto update
# set timezone
# backup

# add cronejob
# time update
# mount hdd

# change hostname

# format hdd
# install resilio