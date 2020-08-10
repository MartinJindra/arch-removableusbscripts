#!/bin/bash
# unmount drive if script is started again
sudo umount -R /mnt/root
# install install-scripts
sudo pacman -Sy --needed arch-install-scripts
# choose disk and format it
sync
lsblk
echo "Drive:"
read drive
cfdisk $drive
mkfs.fat -F32 "$drive"1
mkfs.ext4 -O "^has_journal" "$drive"2
# mount root partition to system
mkdir -p /mnt/root
mount "$drive"2 /mnt/root
# install packages to disk
pacstrap -c /mnt/root linux linux-headers linux-firmware base base-devel grub efibootmgr networkmanager exfat-utils mtools ntfs-3g amd-ucode intel-ucode gnuplot wxmaxima konqueror xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-amdgpu xf86-video-nouveau lxqt sddm kate ktorrent kcalc mpv kpatience ksysguard ksystemlog veracrypt git vim nano partitionmanager bashtop htop openssh openssl sqlmap nmap arp-scan youtube-dl zsh fish bash-completion python-pip python bluez fatresize jfsutils lsof wget arandr openvpn dialog python-setuptools neofetch arch-install-scripts tar xz bzip2 gzip zstd speedtest-cli
# mount boot partition to system
mkdir -p /mnt/root/efi
mount "$drive"1 /mnt/root/efi
# generate fstab
genfstab -U /mnt/root/ >> /mnt/root/etc/fstab
vim /mnt/root/etc/fstab
# copy .zshrc and the config file to disk 
cp config.sh /mnt/root/root
cp .zshrc /mnt/root/root
