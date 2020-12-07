# Arch linux on qemu

## Installation of the system

### Before Start

* Download arch iso

* Create a qemu image for holding arch

    `qemu-img create -f qcow2 archlinux 8G`

* Run archboot.sh 

### Prerequisite

* Enlarge font size

    `setfont iso02-12x22`
    
* Update latest arch database

    `pacman -Syy`

* Install necessary package to continue

    `pacman -S git`

    Note: reflector no longer works on Big Sur (saw it somewhere online), if it works, install it and update mirrors in the below steps

    Note: `reflector` to update mirror channels and `git` for cloning preparation repo

    <!-- * Update mirrors (servers to download programs) -->
    
    <!--     `sudo reflector --country 'Australia' -f 12 -l 12 -p http -n 12 --verbose --save /etc/pacman.d/mirrorlist` -->
    
    <!--     Note: to see the effects, enter `cat /etc/pacman.d/mirrorlist` -->

### Boot 

* partition table

    `fdisk -l /dev/sda`

    `fdisk /dev/sda`

    n for create new partition and then use default options 

* partition file system

    `mkfs.ext4 /dev/sda1`

* mount the file system

    `mount /dev/sda1 /mnt`

    `ls /mnt`

* install base package

    `pacstrap /mnt base base-devel`

* generate file system table in the file system 

    `genfstab /mnt >> /mnt/etc/fstab`

    `cat /mnt/etc/fstab`

* root into the file system

    `arch-chroot /mnt`

### File system 

* set root password

    `passwd`

* install an editor 

    `pacman -S vim`
    
* locale

    `vim /etc/locale.gen`

    Uncomment the following two lines 

        en_US.UTF-8 UTF-8
        en_US ISO-8859-1
    `locale-gen`
    
    `locale > /etc/locale.conf`
    
    `cat /etc/locale.conf`
        
    
* disable sudo password

    `EDITOR=vim visudo`

    Uncomment the following line

        %wheel ALL=(ALL) NOPASSWD: ALL

* network configuration

    `pacman -S dhcpcd` (if this is not working, install `dhcp` as well)

    `systemctl enable dhcpcd`

* hosting

    `echo mbp > /etc/hostname`

    `cat /etc/hostname`

    `vim /etc/hosts`

    Add the followings

        #<ip-address>    <hostname.domain.org>    <hostname>
        127.0.0.1        mbp.localdomain          mbp
        ::1              localhost.localdomain    localhost
        
        # End of file

    Alternatively,

        #<ip-address>    <hostname.domain.org>    <hostname>
        127.0.0.1        localhost.localdomain    localhost
        ::1              localhost.localdomain    localhost
        127.0.1.1        localhost.localdomain    mbp
        
        # End of file

* add user

    `useradd -m -g users -G adm,storage,wheel,power,audio,video -s /bin/bash wenhaowu`

    `passwd wenhaowu`

* install more packages

    `pacman -S rsync git mlocate wireless_tools wpa_supplicant dialog --noconfirm`

    `updatedb`

* install x components

    `pacman -S ttf-dejavu alsa-utils xorg xorg-server xorg-xinit xorg-twm xterm xorg-server-devel`

* install grub and os-prober

    `pacman -S grub os-prober`

* building linux image

    `mkinitcpio -p linux`

    Note: if it fails, run `pacman -S linux linux-firmware`

* grub

    `grub-install /dev/sda`

    `sudo grub-mkconfig -o /boot/grub/grub.cfg`

* exit mechanism

    `exit`

    `umount /mnt -R`

    `poweroff`

### After installation (root)

* reboot

    ```
    qemu-system-x86_64 \
        -k en-us \
        -vga std \
        -m 4096 \
        -usb \
        -device usb-tablet \
        -smp 2 \
        -boot c archlinux
    ```
    
* Log into root

* install more packages

    `git clone https://github.com/midfingr/arch_extras.git`

    `cp /etc/pacman.conf /etc/pacman.conf.back`

    `cp arch_extras/pacman.conf /etc/pacman.conf`

    `cp /etc/makepkg.conf /etc/makepkg.back`

    `cp arch_extras/makepkg.conf /etc/makepkg.conf`

    `pacman -Syy`
    
    `rm -rf arch_extras`

    Note: see the repo for arch_extras/pacman.conf and arch_extras/makepkg.conf

### After installation (user)

* Log into user

* Update latest arch database

    `sudo pacman -Syy`

* install desktop

    `sudo pacman -S xfce4` or 

    `sudo pacman -S plasma-meta`

    ​	`pacman -S dolphin konsole`

    ​	`su`

    ​	`sddm --example-config > /etc/sddm.conf`

    ​	<!-- `vim /etc/sddm.conf` -->

    ​	<!-- Change [Theme] Current and CursorTheme to breeze -->

    ​	`sudo systemctl enable sddm`

    ​	`sudo systemctl enable NetworkManager`

    Note: use 'lxdm' as fallback option for display manager (`sudo pacman -S lxdm`)

* change display manager (optional)

    `sudo pacman -S lightdm`

    `sudo systemctl enable lightdm.service -f`

### Reboot & SSH

* Reboot using default display (i.e. runArchLinux.sh)

    ```
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
    ```
    
* install yay

    * Upgrade your system

        `sudo pacman -Syyu`

    * Clone yay repo

        `git clone https://aur.archlinux.org/yay.git`

    * Install yay

        `cd yay`

        `makepkg -si`

* install openssh

* install tigervnc

* install x11vnc

* install man pages (`man-db`)

* install ntfs-3g (open inline terminal under Dolphin)

## Configurations and Desktop

### Reboot

* Reboot commands (with display)

    ```
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
    ```

* Reboot commands (without display, i.e. headless. Can be used for vnc)

    ```
    qemu-system-x86_64 \
        -k en-us \
        -smp 2 \
        -m 4096 \
        -vga virtio \
        -display none \
        -usb \
        -device usb-tablet \
        -enable-kvm \
        -machine accel=hvf \
        -cpu Penryn,kvm=on,vendor=GenuineIntel \
        -net user,hostfwd=tcp::2222-:22 -net nic \
        -boot c archlinux
    ```

    `&` in shell script means running qemu in the background

    use `sudo poweroff` to shutdown the virtual machine

### SSH & VNC

* ssh from host (macbook) to guest (arch linux)

    * on guest:

        `sudo systemctl start sshd` (start service in this login session)

        `sudo systemctl enable sshd` (start service in each login session)

        `vim /etc/ssh/sshd_config` (uncomment the port and set it to what you wanted, e.g. 22)

        Note: if it is not working, also generate ssh keys by `ssh-keygen`

    * on host:

        `ssh -p 2222 wenhaowu@localhost`

        Note: if known host issues occur, please delete the bug line in `known_hosts` file

* vnc from host (macbook) to guest (arch linux)

    * on guest:

        `vncpasswd` (create password file)

        `sudo vim /etc/tigervnc/vncserver.users` to define user mappings, e.g. :1 wenhaowu

        `sudo vim ~/.vnc/config` (the session name could be seen in the prefix in .desktop file within `/usr/share/xsessions`)

            session=plasma
            geometry=1920x1080
            localhost
            alwaysshared        
        
        `systemctl start vncserver@:1`(Start vncserver on display 1)
        
        `sudo systemctl enable vncserver@:1`(Start vncserver on display 1 on boot)
        
        `systemctl start x11vnc` (Start x11vnc on display 1)
        
        `sudo systemctl enable x11vnc` (Start x11vnc on display 1 on boot)
        
        `systemctl status vncserver@:1` and `systemctl status x11vnc` (check x11vnc status)
        
         <!-- `x11vnc -rfbauth ~/.vnc/passwd -display :1` (start x11vnc) -->
                
        
    * on host:

        connect vncserver by `localhost:5901` (because you set the display to 1)

        Note: use a full feature vncviewer client

        Example usage in mac screens app:

        * General Info

            address: localhost; Port: 5901; Operating System: Linux; Authentication type: VNC Password

        * Secure Connection

            Checked `Enable Secure Connections`; Address: localhost; Port: 2222; Username: ...; Password: ...;

            Note: remember you set qemu port forwarding (2222 to 22)

        Note: in this case, no need to execute x11vnc -rfb... command

    Note: 

    * I've tried qemu display mode, and found couldn't open the display both on vnc and macos CLI qemu at the same time 
    * If CLI qemu is opened, vnc won't work and vice versa
    * If vnc works, then CLI qemu may be black screen. To make CLI qemu work again, comment out settings in /etc/tigervnc/vncserver.users

    References: 

    * [tigervnc, i.e. vncserver](https://wiki.archlinux.org/index.php/TigerVNC)

### X11 forwarding (ToDo)

## References

Midfingr

* [An Arch Install by midfingr](https://www.youtube.com/watch?v=yIQbnvI2WLk)

    * [git repo: pre\_arch](https://github.com/midfingr/pre_arch)

    * [git repo: arch\_extras](https://github.com/midfingr/arch_extras)
    
* [QEMU + Arch Linux by midfingr](https://www.youtube.com/watch?v=nv0CjGdOLxY&t=13s)

    * [git repo: youtube\_notes/qemu\_arch](https://github.com/midfingr/youtube_notes/blob/master/qemu_arch)

* [Plasma 5 install Arch Linux: Take 2](https://www.youtube.com/watch?v=8QtBTZZGzzg)

Reddit

* [How to fix warning about ECDSA host key](https://superuser.com/questions/421004/how-to-fix-warning-about-ecdsa-host-key)

* [How to use qemu to run a non-gui OS on the terminal](https://stackoverflow.com/questions/6710555/how-to-use-qemu-to-run-a-non-gui-os-on-the-terminal)

Others

* [Arch Linux How to Install Yay](https://low-orbit.net/arch-linux-how-to-install-yay)
