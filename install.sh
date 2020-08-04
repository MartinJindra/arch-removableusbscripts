#!/bin/bash
lsblk
echo "Drive:"
read drive
cfdisk $drive
mkfs.fat -F32 "$drive"1
mkfs.ext4 -O "^has_journal" "$drive"2
mkdir /mnt/root
mount "$drive"2 /mnt/root
pacstrap -c /mnt/root linux linux-headers linux-firmware base base-devel grub efibootmgr networkmanager exfat-utils mtools ntfs-3g amd-ucode intel-ucode firefox chromium xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-amdgpu xf86-video-nouveau lxqt sddm kate ghostwriter ktorrent kcalc mpv kpatience ksysguard ksystemlog veracrypt git vim nano partitionmanager bashtop htop openssh openssl sqlmap nmap arp-scan youtube-dl fish bash-completion python-pip python npm nodejs bluez fatresize jfsutils lsof wget arandr openvpn dialog python-pip python-setuptools neofetch arch-install-scripts
mkdir /mnt/root/efi
mount "$drive"1 /mnt/root/efi
genfstab -U /mnt/root/ >> /mnt/root/etc/fstab
vim /mnt/root/etc/fstab
