#!/bin/bash

# update the system
sudo apt-get update
sudo apt-get -y dist-upgrade

# user settings
sudo dpkg-reconfigure tzdata

# change password
passwd

# set hostname
read -p "Enter new hostname [bpi-iot-ros]: " hostname
hostname=${hostname:-bpi-iot-ros}

sudo sed -i "s/127.0.0.1   localhost bpi-iot-ros/127.0.0.1   localhost $hostname/g" /etc/hosts
sudo sed -i "s/::1         localhost bpi-iot-ros ip6-localhost ip6-loopback/::1         localhost $hostname ip6-localhost ip6-loopback/g" /etc/hosts

sudo sh -c "echo $hostname > /etc/hostname"
sudo hostname -F /etc/hostname

# install anacron
sudo apt-get -y install anacron

# cron ntp time hourly
sudo apt-get -y install ntp ntpdate
ntpdate -s 0.de.pool.ntp.org
sudo wget https://raw.githubusercontent.com/linuxluigi/bananapi_resilio_sync/master/cron/hourly/ntpdate.sh -O /etc/cron.hourly/ntpdate
sudo chmod +x /etc/cron.hourly/ntpdate

# activate auto install security updates
sudo apt-get -y install unattended-upgrades
sudo sh -c "echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::Update-Package-Lists "1";' >> /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/10periodic"
sudo sh -c "echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic"

# install Resilio Sync
# https://help.getsync.com/hc/en-us/articles/206178924
echo 'deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free' | sudo tee --append /etc/apt/sources.list.d/resilio-sync.list > /dev/null
wget -qO - https://linux-packages.resilio.com/resilio-sync/key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y resilio-sync
# user rslsync
sudo systemctl enable resilio-sync

# format usb hdd
read -p "Make sure the usb hdd is insert and it will be erase completely [Enter]: " format
sudo mkfs.ext4 /dev/sda
# create mount point
sudo mkdir /resilio-sync
# mount
uuid="$(sudo blkid -s UUID -o value /dev/sda)"
sudo sh -c "echo '/dev/sda /resilio-sync ext4 defaults,noatime,nodiratime,commit=600,errors=remount-ro 0 1' >> /etc/fstab"
sudo mount -a

# create folder structure
sudo mkdir /resilio-sync/server
sudo mkdir /resilio-sync/backup
sudo chown -R rslsync:rslsync /resilio-sync

# backup
sudo apt-get install -y rsnapshot
sudo sh -c "echo 'backup\t/resilio-sync/server/\tlocalhost' >> /etc/rsnapshot.conf"
sudo sed -i 's!snapshot_root\t/var/cache/rsnapshot/!snapshot_root\t/resilio-sync/server/backup!g' /etc/rsnapshot.conf

# add backup cron jobs
# hourly
sudo wget https://raw.githubusercontent.com/linuxluigi/bananapi_resilio_sync/master/cron/hourly/rsnapshot.sh -O /etc/cron.hourly/rsnapshot
sudo chmod +x /etc/cron.hourly/rsnapshot
# daily
sudo wget https://raw.githubusercontent.com/linuxluigi/bananapi_resilio_sync/master/cron/daily/rsnapshot.sh -O /etc/cron.daily/rsnapshot
sudo chmod +x /etc/cron.daily/rsnapshot
# weekly
sudo wget https://raw.githubusercontent.com/linuxluigi/bananapi_resilio_sync/master/cron/weekly/rsnapshot.sh -O /etc/cron.weekly/rsnapshot
sudo chmod +x /etc/cron.weekly/rsnapshot
