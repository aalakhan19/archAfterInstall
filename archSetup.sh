#!/bin/sh

#variables
PP=("firefox" "discord" "nitrogen" "polkit" "neovim" "pulseaudio")
AP=("anki-official-binary-bundle" "typora" "spotify" "iwgtk" "visual-studio-code-bin" "github-desktop-bin")

# update base system
sudo pacman -Syu

# install pacman programms
sudo pacman -S ${PP[@]}

# disable beep
sudo touch /etc/modprobe.d/nobeep.conf
sudo sh -c 'echo blacklist pcspkr >> /etc/modprobe.d/nobeep.conf'

# tty login without username
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo touch /etc/systemd/system/getty@tty1.service.d/skip-username.conf
echo $'[Service]\nExecStart=\nExecStart=-/sbin/agetty -o \'-p -- aala\' --noclear --skip-login - $TERM' | sudo tee -a /etc/systemd/system/getty@tty1.service.d/skip-username.conf >/dev/null

# install yay
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

# install yay programms
yay -S ${AP[@]}

# install xserver
sudo pacman -S xorg xorg-xinit

# install dwm
mkdir -p suckless
cd suckless
git clone https://github.com/aalakhan19/dwm
cd dwm
sudo make clean install
cd

# autostart dwm on login
echo $'if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then\n  exec startx\nfi' >> .bash_profile

# install dwmblocks
cd
mkdir -p suckless
cd suckless
git clone https://github.com/aalakhan19/dwmblocks
cd dwmblocks
sudo make
sudo make install

# install st
cd
mkdir -p suckless
cd suckless
git clone https://git.suckless.org/st
cd st
sudo make clean install

# setup sxhkd
cd
sudo pacman -S sxhkd
mkdir -p .config/sxhkd
cd .config/sxhkd
git clone https://github.com/aalakhan19/sxhkdConfig
cp sxhkdConfig/sxhkdrc sxhkdrc

# setup light
cd 
sudo pacman -S light
sudo touch /etc/udev/rules.d/backlight.rules
sudo sh -c 'echo ACTION==\"add\", SUBSYSTEM==\"backlight\", KERNEL==\"intel_backlight\", RUN+=\"/bin/chgrp video /sys/class/backlight/%k/brightness\" >> /etc/udev/rules.d/backlight.rules'
sudo sh -c 'echo ACTION==\"add\", SUBSYSTEM==\"backlight\", KERNEL==\"intel_backlight\", RUN+=\"/bin/chmod g+w /sys/class/backlight/%k/brightness\" >> /etc/udev/rules.d/backlight.rules'
sudo usermod -aG video aala


# install font
sudo pacman -S ttf-liberation noto-fonts

# setup .xinitrc
cd
pacman -S gnome-keyring
echo $'eval $(/usr/bin/gnome-keyring-daemon --start)\nexport SSH_AUTH_SOCK' >> .xinitrc
echo $'xinput set-prop "MSFT0002:00 04F3:304B Touchpad" "libinput Natural Scrolling Enabled" "1"\nxinput set-prop "MSFT0002:00 04F3:304B Touchpad" "libinput Tapping Enabled" "1"' >> .xinitrc
echo "exec dwm" >> .xinitrc

sudo reboot