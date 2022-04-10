#!/bin/sh
qemu-system-aarch64 -machine raspi3 -smp 4,cores=1 -kernel buildroot/output/images/u-boot.bin -serial null -serial mon:stdio -nographic -device sd-card,drive=mycard -drive if=none,file=buildroot/output/images/2022-01-28-raspios-bullseye-arm64-lite.img,format=raw,id=mycard
