#!/bin/bash
lsblk
echo "Drive:"
read drive
sudo cfdisk $drive
sudo mkfs.fat -F32 "$drive"1
sudo mkfs.ext4 -O "^has_journal" "$drive"2
sudo mkdir /mnt/root
sudo mount "$drive"2 /mnt/root
sudo pacstrap -c /mnt/root linux linux-headers linux-firmware base base-devel grub efibootmgr networkmanager exfat-utils mtools ntfs-3g amd-ucode intel-ucode firefox chromium xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-amdgpu xf86-video-nouveau lxqt sddm kate ghostwriter ktorrent kcalc mpv kpatience ksysguard ksystemlog veracrypt git vim nano partitionmanager bashtop htop openssh openssl sqlmap nmap arp-scan youtube-dl fish bash-completion python-pip python npm nodejs bluez fatresize jfsutils lsof wget arandr openvpn dialog python-pip python-setuptools neofetch arch-install-scripts
sudo mkdir /mnt/root/efi
sudo mount "$drive"1 /mnt/root/efi
sudo genfstab -U /mnt/root/ >> /mnt/root/etc/fstab
sudo vim /mnt/root/etc/fstab
