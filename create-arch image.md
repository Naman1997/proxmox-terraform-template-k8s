# How to create a cloud image for arch

There are 2 ways to create a cloud image for arch
- Follow the instruction in this [repo](https://github.com/hartwork/image-bootstrap) and create an image from scratch
- Use a prebuilt image and configure it to have your custom settings

We will be following the 2nd way as its much faster

Download latest image from https://linuximages.de/openstack/arch/ to your proxmox node

qm importdisk <VM_ID> <IMAGE_NAME>

qemu-img resize <IMAGE_NAME> +97G

Resize your partitions using this guide:
https://geekpeek.net/resize-filesystem-fdisk-resize2fs/

You need to do this when you are in a live environment[CD with Arch ISO]

fdisk /dev/vda

d

p

n

[Don't delete ext4 signature]

p

w

resize2fs /dev/vda1


Refresh keys by
pacman -S archlinux-keyring
pacman-key --refresh
pacman-key --populate

Install vim

visudo

Upgrade arch

Optional : Install my zsh theme
