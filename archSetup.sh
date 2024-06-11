#!/bin/sh

# update base system
sudo pacman -Syu

# disable beep
sudo touch /etc/modprobe.d/nobeep.conf
sudo sh -c 'echo blacklist pcspkr >> /etc/modprobe.d/nobeep.conf'

# tty login without username
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo touch /etc/systemd/system/getty@tty1.service.d/skip-username.conf
echo $'[Service]\nExecStart=\nExecStart=-/sbin/agetty -o \'-p -- aala\' --noclear --skip-login - $TERM' | sudo tee -a /etc/systemd/system/getty@tty1.service.d/skip-username.conf >/dev/null

# install yay
sudo pacman -S vim git curl
cd
mkdir -p Downloads
cd Downloads
pacman -S git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
rm -rf yay-bin
cd

# install xserver
sudo pacman -S xorg xorg-xinit xf86-video-intel

# fix screen tearing
sudo mkdir -p /etc/X11/xorg.conf.d
sudo touch /etc/X11/xorg.conf.d/20-intel.conf
echo $'Section "Device"\n   Identifier "Intel Graphics"\n   Driver "intel"\n   Option "TearFree" "true"\nEndSection' | sudo tee -a /etc/X11/xorg.conf.d/20-intel.conf >/dev/null

# install dwm
mkdir -p suckless
cd suckless
git clone https://github.com/aalakhan19/dwm
cd dwm
sudo make clean install
sudo pacman -S dmenu
cd

# autostart dwm on tty1 login
echo $'if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then\n  exec startx\nfi' >> .bash_profile

# install dwmblocks
cd
mkdir -p suckless
cd suckless
git clone https://github.com/aalakhan19/dwmblocks
cd dwmblocks
sudo make
sudo make install
sudo pacman -S upower

# install st
cd
mkdir -p suckless
cd suckless
git clone https://github.com/aalakhan19/st
cd st
sudo make clean install
yay -S nerd-fonts-fira-code

# setup sxhkd
cd
sudo pacman -S sxhkd
mkdir -p .config/sxhkd
cd .config/sxhkd
git clone https://github.com/aalakhan19/sxhkdConfig
cp sxhkdConfig/sxhkdrc sxhkdrc

# setup light
cd 
yay -S light
sudo touch /etc/udev/rules.d/backlight.rules
sudo sh -c 'echo ACTION==\"add\", SUBSYSTEM==\"backlight\", KERNEL==\"intel_backlight\", RUN+=\"/bin/chgrp video /sys/class/backlight/%k/brightness\" >> /etc/udev/rules.d/backlight.rules'
sudo sh -c 'echo ACTION==\"add\", SUBSYSTEM==\"backlight\", KERNEL==\"intel_backlight\", RUN+=\"/bin/chmod g+w /sys/class/backlight/%k/brightness\" >> /etc/udev/rules.d/backlight.rules'
sudo usermod -aG video aala


# install font
sudo pacman -S ttf-liberation noto-fonts

# setup .xinitrc
cd
echo $'xinput set-prop "MSFT0002:00 04F3:304B Touchpad" "libinput Natural Scrolling Enabled" "1"\nxinput set-prop "MSFT0002:00 04F3:304B Touchpad" "libinput Tapping Enabled" "1"' >> .xinitrc
echo "exec dwm" >> .xinitrc

# set dark theme (NEED TO MANUELLY SET LXAPPEARENCE)
sudo pacman -S lxappearance qt5ct arc-gtk-theme

# init keyring (USE WIKI TO COMPLETE SETUP)
sudo pacman -S gnome-keyring libsecret

# set timezone
timedatectl set-timezone Europe/Berlin

# install packages

sudo pacman -S firefox nitrogen evince
yay -S visual-studio-code-bin

sudo reboot