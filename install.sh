#! /bin/bash


# Georgio Ghazzi's  EFI Arch Installation Script


echo "Georgio Ghazzi's EFI Arch Installation."
echo "---------------------------------------"
echo ""


### Check if connected to internet.

while true
do
    read -p 'Are you connected to internet? [y/N]: ' internetStts
 
 case $internetStts in
     [yY][eE][sS]|[yY])
 break
 ;;
     [nN][oO]|[nN])
 echo "Connect to internet to continue..."
 exit
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done



### Set NTP On

# timedatectl set-ntp true




### Select Drive To Install Arch On

selectDrive() {
# Dynamic Menu Function
createmenu () {
    select selected_option; do # in "$@" is the default
        if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#)) ]; then
            break;
        else
            echo "Please make a vaild selection (1-$#)."
        fi
    done
}

declare -a drives=();
# Load Menu by Line of Returned Command
mapfile -t drives < <(lsblk --nodeps -o name,serial,size | grep "sd");
# Display Menu and Prompt for Input
echo "Available Drives (Please select one):";
createmenu "${drives[@]}"
# Split Selected Option into Array and Display
drive=($(echo "${selected_option}"));
}

#Use Select Drive Function
selectDrive

while true
do
echo "you have selected the following drive [/dev/${drive[0]}]"

    read -p 'Are you sure of this selection ?[y/N]: ' driveConf
 
 case $driveConf in
     [yY][eE][sS]|[yY])
     TGTDEV=/dev/${drive[0]}
 break
 ;;
     [nN][oO]|[nN])
 echo "Please Select the a drive!"
 selectDrive
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done

echo $TGTDEV'1'


sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 512 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +8G # 8 GB root parttion
  n # new partition
  p # primary partition
  3 # partion number 3
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF


### Format Partitions
mkfs.fat -F32 $TGTDEV'1'
mkfs.ext4 $TGTDEV'2'
mkfs.ext4 $TGTDEV'3'

### Mount Partition
mount $TGTDEV'2' /mnt
mkdir /mnt/home
mount $TGTDEV'3' /mnt/home
mkdir /mnt/boot/efi
mount $TGTDEV'1' /mnt/boot/efi

### Starting Install
pacstrap /mnt base linux linux-firmware nano 


### Generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

cp -rvf post-install.sh /mnt
chmod a+x /mnt/post-install.sh

echo "Please Run post-install.sh after chrooting to /mnt"
echo "Press any key to continue"
read temp
### Switching to mnt 
arch-chroot /mnt /bin/bash
 
