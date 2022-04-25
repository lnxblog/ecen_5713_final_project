# ecen_5713_final_project #

This repo contains files and documentation on performing Remote OS update on the Raspberry Pi 3B

## Flashing procedure

The below steps describe in detail the procedure for the OS update

### Stage 1: Booting into U-Boot 
U-boot provides options to interrupt the normal bootflow process and load the next stage which is the initramfs.

In order for the Raspberry Pi firmware to pickup the U-Boot during boot instead of the Linux kernel image, we need to modify the config.txt as below.
```
kernel=u-boot.bin
enable_uart=1
```
This tells the firmware to use u-boot.bin as the kernel and print boot log messages over UART. The u-boot.bin file needs to be available in the boot partition of the SD card which uses the FAT filesystem.


### Stage 2: Booting into initramfs ##
Once we are in the U-boot environment we need to perform the necessary steps to boot into the initramfs.

The Raspberry Pi uses two partitions
1. boot parition (FAT filesystem)
2. root filesystem partition (ext4 filesystem)

The kernel is stored in the boot parition and filesystem in the other.
We have stored the initramfs image in the boot partition along with the kernel

In the u-boot environment, the environment variables for load addresses are already part of the u-boot image. To boot into the initramfs we need to run the below commands in the u-boot console
```
$ fatload mmc 0:1 ${kernel_addr_r} Image
$ fatload mmc 0:1 ${ramdisk_addr_r} uRamdisk
$ setenv bootargs "earlycon coherent_pool=1M 8250.nr_uarts=1 console=ttyS0,115200 rdinit=/bin/sh"
$ booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr}  
```
The `kernel_addr_r` variable contains the load address for the kernel, `ramdisk_addr_r` contains address for initramfs image and `fdt_addr' contains the address of the device tree. Device tree is already part of the U-boot image.

### Stage 3: Download Images

Once we get a shell in the initramfs we perform the download of images using from the Host PC.

We need to connect the Pi to the Host PC with an ethernet cable and configure the ethernet interfaces on both ends with IP addresses in the same subnet range.

We can then download the kernel and rfs images using a utility like tftp. A tftp server needs to be configured on the Host PC with the path to a folder containing the images.

### Stage 4: Flash the images
To flash the kernel we to copy it into the boot partition of the SD card. The existing `Image` file will be overwritten by the copy.
The boot partition needs to be mounted before being accessed.
```
mount -t /dev/mmcblk0p1 /tmp/boot
```

Similarly the the RFS images is downloaded in gzip format as it is big. Extracting large files on the initramfs is not possible as this eats away the RAM. 
So an option is to unzip it and pipe it to the RFS partition
```
gunzip -c rootfs.ext2.gz | dd  of=/dev/mmcblk0 seek=532480
```

The flashing is now completed. Upon rebooting the new kernel and RFS is loaded.
