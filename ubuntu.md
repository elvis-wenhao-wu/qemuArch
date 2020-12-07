# QEMU setup for Ubuntu Desktop 

Installation and Reboot:

* [Ubuntu desktop on macos](https://graspingtech.com/ubuntu-desktop-18.04-virtual-machine-macos-qemu/)

    * Boot commands

    ```
    qemu-system-x86_64 \
      -m 2048 \
      -vga virtio \
      -display default,show-cursor=on \
      -usb \
      -device usb-tablet \
      -enable-kvm \
      -cdrom ~/QEMU/ubuntu-18.04.3-desktop-amd64.iso \
      -drive file="/Users/wenhaowu/QEMU/ubuntu-desktop-18.04.qcow2",if=virtio \
      -machine accel=hvf \
      -cpu Penryn,kvm=on,vendor=GenuineIntel \
      -net user,hostfwd=tcp::2222-:22 -net nic
    ```

    * Run commands

    ```
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
    ```

Note:

* If you're using Ubuntu desktop, use Main server instead of Aus server

    https://askubuntu.com/questions/1198621/apt-get-cannot-connect-to-ubuntu-archives

* If you want to resize ubuntu desktop, using gparted is fine. Otherwise, refer to `Resize qcow2 image ALT 3` below

    https://sandilands.info/sgordon/increasing-kvm-virtual-machine-disk-using-lvm-ext4

Reference: 

* [Resize qcow2 image ALT 1](https://maunium.net/blog/resizing-qcow2-images/)

* [Resize qcow2 image ALT 2](https://serverfault.com/questions/324281/how-do-you-increase-a-kvm-guests-disk-space)

* [Resize qcow2 image ALT 3](https://sandilands.info/sgordon/increasing-kvm-virtual-machine-disk-using-lvm-ext4)

* [Ubuntu server on macos](https://www.naut.ca/blog/2020/08/26/ubuntu-vm-on-macos-with-libvirt-qemu/)

* [commands options explained](https://www.arthurkoziel.com/qemu-ubuntu-20-04/)

