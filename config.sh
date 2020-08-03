#!/bin/bash
sudo ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime
sudo hwclock --systohc
echo "Please enter name for computer: "
read pcname
sudo echo $pcname > /etc/hostname;
sudo echo "KEYMAP=de-latin1" > /etc/vconsole.conf
sudo echo "LANG=de_AT.UTF-8" > /etc/locale.conf
sudo echo "127.0.0.1		localhost" >> /etc/hosts
sudo echo "::1		localhost" >> /etc/hosts
sudo echo "127.0.1.1		lxUSB.localdomain  lxUSB" >> /etc/hosts
sudo echo "de_AT.UTF-8 UTF-8" >> /etc/locale.gen
sudo echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
sudo locale-gen
echo "Password for root:"
sudo passwd
echo "New User:"
read username
sudo useradd $username -m -G users -s /bin/fish
sudo passwd $username
sudo chmod +w /etc/sudoers
sudo echo "$username ALL=(ALL) ALL" > /etc/sudoers
sudo chmod -w /etc/sudoers
sudo usermod root -s /bin/fish
sudo grub-install --target=x86_64-efi --efi-directory=/efi --removable
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable sddm
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo pip3 install protonvpn-cli
