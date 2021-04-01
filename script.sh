#!/bin/bash

###########################################
# Part - 1  Add eth1 interface in the config
###########################################
#IFACE=eth1
#read MAC < /sys/class/net/$IFACE/address
#cat > /etc/sysconfig/network-scripts/ifcfg-$IFACE << EOF_NET
#BOOTPROTO=dhcp
#DEVICE=$IFACE
#HWADDR=$MAC
#ONBOOT=yes
#TYPE=Ethernet
#USERCTL=no
#EOF_NET
#ifdown $IFACE
#ifup $IFACE


###########################################
# Part - 2  Adding a new partion using fdisk
###########################################
yum install lvm2 -y
fdisk /dev/vdb << FDISK_OPT
n
p
1


t
8e
w
FDISK_OPT
partprobe                                       #Inform the OS of partition table changes

###########################################
# Part - 4  Creating Physical volume, Volume Group, Logical Volume, File System
###########################################
yum install lvm2 -y                            #lvm2 is the format type
#pvdisplay                                       #Display various attributes of physical volume
pvcreate /dev/vdb1                              #Initialize physical volume for use by LVM
#vgdisplay                                      #Display volume group information
vgcreate vg01 /dev/vdb1                         #Create a volume group
lvcreate -n lvu01app02 -l 100%FREE vg01         #Create a logical volume, doesnt not like "-" in lv name.
#lvdisplay                                      #Display information about a logical volume
echo "/dev/mapper/vg01-lvu01app02 /u01/app02/ xfs defaults 0 0 " >> /etc/fstab
mkfs.xfs /dev/mapper/vg01-lvu01app02
mkdir -p /u01/app02 && mount /dev/mapper/vg01-lvu01app02
