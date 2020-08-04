# ArchRemovableInstallScripts

## Caution
This two scripts can install a custom version of archlinux on a flash drive.
The code is not yet finished to deal with every exception that can happen.
For example if the user inputs the wrong drive and so on.
So please be aware.
It it just a summary of my most important options for a functional desktop experience.

## Usage
1. execute the install-script
`sudo sh install.sh`
2. when creating the partition, the first partition should be an **EFI**-partition with 256 to 512 MiB and the second partition as an ext4 root partition 
3. copy the **config.sh** to **/mnt/root/root**
4. change into the usb-stick `sudo arch-chroot /mnt/root` 
5. execute `sh config.sh`
