# ecen_5713_final_project #

This repo contains files and documentation on performing Remote OS update on the Raspberry Pi 3B

## Booting into initramfs ##
This section covers booting into initramfs on the Raspberry Pi 3B using U-boot.

The Raspberry Pi using two partitions
1. boot parition (FAT filesystem)
2. root filesystem partition (ext4 filesystem)

The kernel is stored in the boot parition and requires to be loaded into memory by the RPi's own proprietary bootloader. 
We can modify the config.txt file in the boot partition to tell the bootloader to boot into U-boot instead of the kernel.

Once in the U-boot console, we can load the initramfs image along with the kernel and device tree all of which are present on the boot partition and boot into the initramfs.
