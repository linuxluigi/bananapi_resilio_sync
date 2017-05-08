# Bananapi Resilio Sync
Installscript for resilio sync on a Bananapi

# Preparation
 
## Download Ubuntu 16.04 minimal

Go to the official site of banana pi and download Ubuntu 16.04 for 
your device
* Download link: http://www.banana-pi.org/download.html
* Image description: http://forum.banana-pi.org/t/bpi-m1-bpi-m1-new-image-ubuntu-16-04-xenial-minimal-preview-bpi-m1-m1p-r1-img-2016-07-10/1990

## Copy the image to the SD card

Example for Banana Pi Mark 1

```
unzip 2016-07-10-ubuntu-16.04-xenial-minimal-preview-bpi-m1-m1p-r1.img.zip
sudo dd if=2016-07-10-ubuntu-16.04-xenial-minimal-preview-bpi-m1-m1p-r1.img of=/dev/sdX bs=32MB status=progress && sync
```

## Boot the Banana Pi for the first time
To boot the Banana Pi you have to connect it to a monitor, keyboard & ethernet.
Than you can log into your Pi with ```root```/```bananapi``` and install openssh-server.
```
apt update && apt install openssh-server
```
This take some minutes and after successfully install openssh-server you can contine
direct over network or shut it down and move it to another place with 
```shutdown -h now```

## Log into your Banana Pi over network

* Host: ```bpi-iot-ros```
* User: ```pi```
* Password: ```bananapi```


Log into with a  terminal ```ssh pi@bpi-iot-ros```

## Expand the filesystem
Run ```sudo fdisk /dev/mmcblk0``` and it should show you:
```bash
pi@bpi-iot-ros:~$ sudo fdisk -l
Disk /dev/mmcblk0: 7.4 GiB, 7948206080 bytes, 15523840 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000ebf83

Device         Boot  Start     End Sectors  Size Id Type
/dev/mmcblk0p1 *    204800  729087  524288  256M  c W95 FAT32 (LBA)
/dev/mmcblk0p2      729088 3071999 2342912  1.1G 83 Linux
pi@bpi-iot-ros:~$ ^C
pi@bpi-iot-ros:~$ sudo fdisk /dev/mmcblk0

Welcome to fdisk (util-linux 2.27.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help):
```

Press ```p``` to print the partition table

```bash
Command (m for help): p
Disk /dev/mmcblk0: 7.4 GiB, 7948206080 bytes, 15523840 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000ebf83

Device         Boot  Start     End Sectors  Size Id Type
/dev/mmcblk0p1 *    204800  729087  524288  256M  c W95 FAT32 (LBA)
/dev/mmcblk0p2      729088 3071999 2342912  1.1G 83 Linux

Command (m for help):
```

Than press the following buttons:
* ```d``` to delete a partition
* ```2``` to choose the second partition
* ```n``` to create a new partition
* ```p``` to select primary as partition type
* ```2``` to accept 2 as default partition number
* just press```Enter``` to accept the default value for First sector
* just press```Enter``` to accept the default value for last sector
* ```w``` to write the new partition table

The output should look like:

```bash
Command (m for help): d
Partition number (1,2, default 2): 2

Partition 2 has been deleted.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (2048-15523839, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-204799, default 204799): 

Created a new partition 2 of type 'Linux' and of size 99 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Re-reading the partition table failed.: Device or resource busy

The kernel still uses the old table. The new table will be used at the next reboot or after you run partprobe(8) or kpartx(8).

pi@bpi-iot-ros:~$
```

When it was successful reboot your device with ```sudo reboot``` and log into your device after it's up again.

# Add your Public key to the Banana Pi

```bash
ssh pi@bpi-iot-ros 'bash <(wget -qO- https://raw.githubusercontent.com/linuxluigi/bananapi_resilio_sync/master/script/sudo.sh)'
cat ~/.ssh/id_rsa.pub | ssh pi@bpi-iot-ros 'cat>> ~/.ssh/authorized_keys' 
ssh pi@bpi-iot-ros 'bash <(wget -qO- https://raw.githubusercontent.com/linuxluigi/bananapi_resilio_sync/master/script/sshd_config.sh)'
```

# Run the Script
```bash
ssh pi@bpi-iot-ros 'bash <(wget -qO- https://raw.githubusercontent.com/linuxluigi/bananapi_resilio_sync/master/script/install.sh)'
```

Login via ```pi:8888``` and don't forget to set the default sync folder at ```/resilio-sync/server```