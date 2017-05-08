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

# syncron ntp time hourly
sudo apt-get -y install ntp ntpdate
ntpdate -s 0.de.pool.ntp.org

sudo sh -c "echo '#!/bin/bash' > /etc/cron.hourly/ntpdate"
sudo sh -c "echo 'ntpdate -s 0.de.pool.ntp.org' >> /etc/cron.hourly/ntpdate"


# activate auto install security updates
sudo apt-get -y install unattended-upgrades
sudo sh -c "echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::Update-Package-Lists "1";' >> /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic"

# secure
# backup

# add cronejob
# time update
# mount hdd

# change hostname

# format hdd
# install resilio