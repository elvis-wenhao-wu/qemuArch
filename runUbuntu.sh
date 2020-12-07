#!/bin/zsh

qemu-system-x86_64 \
  -m 4096 \
  -vga virtio \
  -display default,show-cursor=on \
  -usb \
  -device usb-tablet \
  -enable-kvm \
  -drive file="/Users/wenhaowu/QEMU/ubuntu-desktop-20.04.qcow2",if=virtio \
  -machine accel=hvf \
  -cpu Penryn,kvm=on,vendor=GenuineIntel \
  -net user,hostfwd=tcp::2222-:22 -net nic
