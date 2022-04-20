#!/bin/sh

# Modify kernel,dtb and sd card image path as per your system

qemu-system-aarch64 -M raspi3 -kernel buildroot/output/images/Image -dtb buildroot/output/images/bcm2710-rpi-3-b.dtb -m 1024 -nographic -append "rw console=ttyAMA0,115200 root=/dev/mmcblk0 fsck.repair=yes rootwait" -device sd-card,drive=mycard -drive if=none,file=buildroot/output/images/rootfs.ext2,format=raw,id=mycard
