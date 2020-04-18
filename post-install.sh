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
export LANG=en_US.UTF-8

### Set Hostname
echo "geo-arch" > /etc/hostname
echo "127.0.1.1 geo-arch.localdomain  geo-arch" >> /etc/hosts

### Configure pacman
sed -i '/Color/s/^#//g' /etc/pacman.conf
sed -i '/TotalDownload/s/^#//g' /etc/pacman.conf
sed -i '/VerbosePkgLists/s/^#//g' /etc/pacman.conf
sed -i '/^Color.*/i ILoveCandy' /etc/pacman.conf
pacman -Syy

### Install NetworkManager Grub and efiBootMgr Sudo
pacman -S networkmanager grub efibootmgr sudo bash-completion --noconfirm



### User Add
useradd -m -g users -G wheel,storage,power  -s /bin/bash georgioghazzi
passwd georgioghazzi

### Allow Sudo
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers

### Configure EFI
mount -t efivarfs efivarfs /sys/firmware/efi/efivarfs
bootctl install
exec 3<> /boot/loader/entries/arch.conf
    echo "title Arch Linux" >&3
    echo "linux /vmlinuz-linux" >&3
    echo "initrd /initramfs-linux.img" >&3
exec 3>&-
echo "options root=PARTUUID=$(blkid -s PARTUUID -o value "


### Enable NetworkManager
systemctl enable NetworkManager



passwd 