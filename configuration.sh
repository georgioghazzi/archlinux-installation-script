#! /bin/bash


# Georgio Ghazzi's  Arch Configuration


### Configuring xorg to load i3
cp /etc/X11/xinit/xinitrc ~/.xinitrc

sed -i '$d' .xinitrc 
sed -i '$d' .xinitrc 
sed -i '$d' .xinitrc 
sed -i '$d' .xinitrc 
sed -i '$d' .xinitrc 

echo "exec i3" >> .xinitrc


### Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

### Install AUR Package
yay -S anydesk-bin betterlockscreen cheat chromedriver cli-visualizer fkill franz google-chrome howdoi mopidy-mpd mopidy-spotify package-query polybar rofi-emoji rofi-greenclip simple-mtpfs tty-font-awesome-4 tty-clock-borderless


### Install yadm
yay -S yadm
yadm clone https://github.com/georgioghazzi/.dotfiles


