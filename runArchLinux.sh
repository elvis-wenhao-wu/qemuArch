#!/bin/zsh

qemu-system-x86_64 \
  -k en-us \
  -smp 2 \
  -m 4096 \
  -vga virtio \
  -display default,show-cursor=on \
  -usb \
  -device usb-tablet \
  -enable-kvm \
  -machine accel=hvf \
  -cpu Penryn,kvm=on,vendor=GenuineIntel \
  -net user,hostfwd=tcp::2222-:22 -net nic \
  -boot c archlinux

