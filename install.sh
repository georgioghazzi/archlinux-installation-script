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

### Use Select Drive Function
selectDrive

TGTDEV=/dev/${drive[0]}

while true
do
echo -e "you have selected the following drive \e[31m[$TGTDEV]\e[0m"
echo ""
echo -e "\e[31mCaution This Will format [$TGTDEV] and create the following partitions:\e[0m"
echo    "------------------------------------------------------------------------"
echo ""
echo "boot partition : [$TGTDEV'1']"
echo "root partition : [$TGTDEV'1']"
echo ""

    read -p 'Are you sure of this selection ?[y/N]: ' driveConf
 
 case $driveConf in
     [yY][eE][sS]|[yY])
 break
 ;;
     [nN][oO]|[nN])
 echo "Please Select a drive!"
 selectDrive
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done



### Create Partition
sgdisk -Z $TGTDEV
sgdisk -n 0::+1GiB -t 0:ef00 -c 0:boot $TGTDEV
sgdisk -n 0:: -t 0:8300 -c 0:root $TGTDEV



### Format Partitions
mkfs.vfat $TGTDEV'1'
mkfs.ext4 $TGTDEV'2'

### Mount Partition
mount $TGTDEV'2' /mnt
mkdir /mnt/boot /mnt/home
mount $TGTDEV'1' /mnt/boot/
mount $TGTDEV'2' /mnt/home

### Starting Install
yes '' | pacstrap -i /mnt base base-devel linux linux-firmware bash man-db nano 


### Generating fstab
genfstab -U -p /mnt >> /mnt/etc/fstab


cp -rvf post-install.sh /mnt
chmod a+x /mnt/post-install.sh

echo "Please Run post-install.sh after chrooting to /mnt"
echo "Press any key to continue"
read temp
### Switching to mnt 
arch-chroot /mnt /bin/bash 
 
