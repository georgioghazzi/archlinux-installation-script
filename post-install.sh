#! /bin/bash


# Georgio Ghazzi's  Arch Configuration


echo "Georgio Ghazzi's Arch Configuration."
echo "---------------------------------------"
echo ""


### use Beirut as Localtime
ln -sf /usr/share/zoneinfo/Asia/Beirut /etc/localtime

### Configure Time
hwclock --systohc --utc


### Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

### Set Hostname
echo "geo-arch" > /etc/hostname
echo "127.0.1.1 geo-arch.localdomain  geo-arch" >> /etc/hosts


### Install NetworkManager Grub and efiBootMgr Sudo
pacman -S networkmanager grub efibootmgr sudo --noconfirm


### Configure GRUB 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

### User Add
useradd -m -g users -G wheel -s /bin/bash georgioghazzi
passwd georgioghazzi

### Allow Sudo
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers

### Enable NetworkManager
systemctl enable NetworkManager



passwd 