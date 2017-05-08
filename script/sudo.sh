#!/bin/bash

# deactivate for password for sudo
sudo sed -i 's/%sudo	ALL=(ALL:ALL) ALL/%sudo ALL=NOPASSWD: ALL/g' /etc/sudoers

# change owner of pi home
sudo chown -R pi:pi /home/pi

# create ~/.ssh/authorized_keys
mkdir ~/.ssh
touch ~/.ssh/authorized_keys

chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys