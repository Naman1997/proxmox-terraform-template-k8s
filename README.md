# terraform-k8s-template

Template for setting up VMs for a new cluster in a Proxmox box.

This repo is using the telmate/proxmox provider for terraform.

Make sure to read the [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) to understand all the variables being used in the variables.tf file

## Important variables to update

In the main.tf file :
- IP_ADDRESS_PROXMOX: This is the IP address of your proxmox box.
- PROXMOX_USERNAME: The username which you want terraform to use
- PROXMOX_PASSWORD: Password for the user mentioned above


In the variables.tf file:
- CLONE_PATH: Name of the proxmox template that will be cloned to form the VMs.
- NAME_SERVER: Nameserver that will be configured for your VMs.

**CLONE_PATH should be present before proceed further**

This is basically a VM where you have installed the following packages:
- vim
- git
- inetutils
- openssh
- docker
- nfs-utils
- figlet
- htop
- net-tools
- qemu-guest-agent
- cloud-guest-utils

Basically run this command in that VM before converting it to a template:

```
sudo pacman -S --needed - < pkglist.txt
```

Learn more about how to create a template [here](https://pve.proxmox.com/wiki/VM_Templates_and_Clones#Create_VM_Template)

## Extra configs
There are some params that are not mentioned in the docs. Look [here](https://github.com/Telmate/terraform-provider-proxmox/blob/master/proxmox/resource_vm_qemu.go) to learn more.

One of the params that we're using is 'guest_agent_ready_timeout', its been set to '60' as it speeds up the creation of VMs this way. Look at this [issue](https://github.com/Telmate/terraform-provider-proxmox/issues/325) to learn more.

I'm also assuming that your bridge name is "vmbr0" in main.tf. Please change it if you have a custom bridge solution setup.

## Create the VMs
```
terraform init
# Make sure the config looks good
terraform plan
terraform apply
```
## Post install steps
Arch will ask you to reset the user password the first time you try to login.