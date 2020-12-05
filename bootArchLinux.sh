#!/bin/zsh

qemu-system-x86_64 \
  -smp 2 \
  -m 4096 \
  -vga virtio \
  -display default,show-cursor=on \
  -usb \
  -device usb-tablet \
  -boot order=d \
  -cdrom "/Users/wenhaowu/QEMU/archlinux-2020.12.01-x86_64.iso" \
  -drive file="/Users/wenhaowu/QEMU/archlinux"
  -machine accel=hvf \
  -cpu Penryn,kvm=on,vendor=GenuineIntel \
