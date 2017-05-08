#!/bin/bash

# secure ssh
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

# reload ssh server
sudo /etc/init.d/ssh reload