#!/bin/bash

# set timezone
ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime
hwclock --systohc

# set system name
read -rp 'Please enter name for computer: ' pcname
echo "$pcname" > /etc/hostname;

# set keyboard layout
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

# set language 
echo "LANG=de_AT.UTF-8" > /etc/locale.conf

# set network configuration
echo "127.0.0.1		localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1		$pcname.localdomain  $pcname" >> /etc/hosts

# generate locale 
echo "de_AT.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

# add light gtk greeter to lightdm config
#sed -i '/^\[Seat:\*\]/a greeter-session=lightdm-gtk-greeter' /etc/lightdm/lightdm.conf

# set password for root
echo "Password for root:"
passwd root

# set new user
read -rp 'New User: ' uname
useradd "$uname" -m -G users -s "$(which zsh)"
passwd "$uname"

# set permission for new user for sudo
chmod +w /etc/sudoers
echo "$uname ALL=(ALL) ALL" >> /etc/sudoers
chmod -w /etc/sudoers

# copy shell scripts to home dir
usermod root -s /bin/zsh
cp .zshrc "/home/$uname/"
cp .bashrc "/home/$uname/"

# install grub
grub-install --target=x86_64-efi --efi-directory=/efi --removable
grub-mkconfig -o /boot/grub/grub.cfg

# enable display manager, networkmanager and bluetooth
if [ -x "$(command -v systemctl)" ];
then
    systemctl enable sddm
    systemctl enable NetworkManager
elif [ -x "$(command -v rc-update)" ]; 
then 
    rc-update add sddm
    rc-update add NetworkManager
fi
