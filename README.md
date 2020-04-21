# Arch Linux Installation Script

## Table of Contents

- [About](#about)
- [Usage](#usage)

## About <a name = "about"></a>

3 scripts to install and configure arch linux without a DM, and with i3wm.


### Usage

Download Arch linux ISO from [here](https://www.archlinux.org/download/) and boot from it.

Update pacman source 

```
pacman -Sy
```

Install git

```
pacman -S git
```

clone this repo and go to it's folder

```
git clone https://github.com/georgioghazzi/archlinux-installation-script
cd archlinux-installation-script
```

Run install.sh and follow the instructions provided;

```
./install.sh
```

when install.sh is done , and you have chroot-ed into /mnt open post-install.sh and follow the instructions provided;

```
./post-install.sh
```

when post-install.sh is done , please reboot and login using the user you created , #NOT THE ROOT USER# and run configuration.sh which is located in /

```
/configuration.sh
```

And done.



