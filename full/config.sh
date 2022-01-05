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
yadm clone https://git.derchef.site/derchef/dotfiles
yadm submodule update --init

# add user to groups
groupadd wireshark
groupadd kismet
usermod "$uname" -aG wheel
usermod "$uname" -aG libvirt
usermod "$uname" -aG wireshark
usermod "$uname" -aG kismet

# set permission for new user for sudo
chmod +w /etc/sudoers
echo "$uname ALL=(ALL) ALL" >> /etc/sudoers
chmod -w /etc/sudoers

# copy shell scripts to home dir
# user
usermod root -s /bin/bash

# make user own the config files
chown -R "$uname:$uname" "/home/$uname/.oh-my-zsh"  
chown -R "$uname:$uname" "/home/$uname/.config"
chown "$uname:$uname" "/home/$uname/.zshrc"
chown "$uname:$uname" "/home/$uname/.bashrc"

# install grub
grub-install --target=x86_64-efi --efi-directory=/efi --removable
grub-mkconfig -o /boot/grub/grub.cfg

# enable display manager, networkmanager
if [ -x "$(command -v systemctl)" ];
then
    systemctl enable sddm
    systemctl enable NetworkManager
    systemctl enable libvirtd
    systemctl enable sshd
    systemctl enable tlp
elif [ -x "$(command -v rc-update)" ]; 
then 
    rc-update add sddm
    rc-update add NetworkManager
    rc-update add libvirtd 
    rc-update add sshd
    rc-update add tlp
fi
