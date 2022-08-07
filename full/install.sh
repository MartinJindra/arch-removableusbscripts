#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]];
then
    echo "Not running as root"
    exit
else
    mountpoint="/mnt/root"

    # unmount drive if script is started again
    if [[ $(mount | grep "$mountpoint") ]];
    then
        umount -R $mountpoint
    fi

    # install install-scripts
    pacman -Sy --needed --noconfirm arch-install-scripts dosfstools

    # choose disk and format it
    sync
    lsblk
    read -rp 'Name of the drive: ' drive

    if [[ $(mount | grep -c "$drive") -eq 0 ]];
    then
        cfdisk "$drive"
        mkfs.fat -F32 "$drive"1
        mkfs.ext4 -O "^has_journal" "$drive"2

        # mount root partition to system
        mkdir -p "$mountpoint"
        mount "$drive"2 "$mountpoint"

        # install packages to disk
        release=$(head -n 1 /etc/os-release)
        packages=(linux-firmware base base-devel grub efibootmgr exfat-utils mtools ntfs-3g amd-ucode intel-ucode tlp grub-customizer meld gnome-disk-utility gnuplot wxmaxima networkmanager qutebrowser chromium firefox falkon vivaldi vivaldi-ffmpeg-codecs gst-plugins-good gst-libav xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-amdgpu xf86-video-nouveau virtualbox virtualbox-host-modules-arch libvirt qemu qemu-arch-extra virt-manager kitty plasma kde-applications transmission-cli transmission-gtk mpv kpat veracrypt git neovim nano bpytop htop openssh openssl sqlmap nmap arp-scan yt-dlp starship fish zsh zsh-syntax-highlighting zsh-autosuggestions zsh-completions bash-completion python-pip python bluez fatresize jfsutils lsof wget neofetch arch-install-scripts tar xz bzip2 gzip zstd speedtest-cli reflector)
        if [[ "$release" == 'NAME="Arch Linux"' ]];
        then
            pacstrap -c "$mountpoint" linux linux-headers linux-docs sddm vagrant "${packages[@]}"
        elif [[ "$release" = 'NAME="Artix Linux"' ]];
        then
            pacstrap -c $mountpoint linux linux-headers linux-docs openrc elogind-openrc networkmanager-openrc sddm-openrc libvirt-openrc tlp-openrc artix-archlinux-support "${packages[@]}"
        elif [[ "$release" = 'NAME="Manjaro Linux"' ]];
        then
            pacstrap -c "$mountpoint" linux515 linux515-headers linux515-docs sddm vagrant "${packages[@]}"
        fi

        # mount boot partition to system
        mkdir -p "$mountpoint"/efi
        mount "$drive"1 "$mountpoint"/efi

        # generate fstab
        chmod +w "$mountpoint"/etc/fstab
        genfstab -U "$mountpoint" >> "$mountpoint"/etc/fstab
        nvim "$mountpoint"/etc/fstab

        # set dotfiles
        yadm clone https://git.mjindra.eu/derchef/dotfiles
        yadm submodule update --init
        cp config.sh "$mountpoint"/root
    fi
fi
