#!/bin/bash
ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime
hwclock --systohc
echo "Please enter name for computer: "
read pcname
echo $pcname > /etc/hostname;
echo "KEYMAP=de-latin1" > /etc/vconsole.conf
echo "LANG=de_AT.UTF-8" > /etc/locale.conf
echo "127.0.0.1		localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1		$pcname.localdomain  $pcname" >> /etc/hosts
echo "de_AT.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "Password for root:"
passwd
echo "New User:"
read username
useradd $username -m -G users -s /bin/fish
passwd $username
chmod +w /etc/sudoers
echo "$username ALL=(ALL) ALL" >> /etc/sudoers
chmod -w /etc/sudoers
usermod root -s /bin/zsh
usermod $username -s /bin/fish
grub-install --target=x86_64-efi --efi-directory=/efi --removable
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth
pip3 install instaloader
cp .zshrc "/home/$username/"
