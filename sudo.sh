#!/bin/bash

# deactivate for password for sudo
sudo sed -i 's/%sudo	ALL=(ALL:ALL) ALL/%sudo ALL=NOPASSWD: ALL/g' /etc/sudoers
