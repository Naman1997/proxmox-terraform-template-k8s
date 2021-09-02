# proxmox-terraform-template-k8s
 
 [![Terraform](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml/badge.svg)](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml)

Template for setting up VMs for a new cluster in a Proxmox box.

Also creates a handy ansible inventory in ansible/hosts.

This repo is using the telmate/proxmox provider for terraform.

Make sure to read the [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) to understand all the variables being used in the variables.tf file

## Important variables to update

All mandatory variables are put in a file named 'terraform.tfvars'.
You can make this file by copying terraform.tfvars.example and updating the values in it. Also rename it to terraform.tfvars

```
cp terraform.tfvars.example terraform.tfvars
# Edit this file and save it
vim terraform.tfvars
```
Description for all vars in terraform.tfvars is available in 'variables.tf' file
Apart from these you can you can also edit other variables in 'variables.tf' file.
These variables are hard-coded in main.tf as I don't think most people would move away from these defaults. Please update main.tf if you need other defaults

```
<!-- Proxmox TLS check -->
pm_tls_insecure = true
<!-- Full cloning for all VMs -->
full_clone = true
<!-- This one is explained below in 'Extra configs' section -->
guest_agent_ready_timeout = 60
<!-- SSH port for all VMs -->
ansible_port = 22
```

**CLONE_TEMPLATE should be present before proceed further**

Learn more about how to create a template [here](https://pve.proxmox.com/wiki/VM_Templates_and_Clones#Create_VM_Template)

You can also follow one of the guides below to create a template VM:
- My [repo](https://github.com/Naman1997/arch-cloud-image) for setting up an arch cloud image
- Telmate's [ISO builder](https://github.com/Telmate/terraform-ubuntu-proxmox-iso)

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

This will also create an ansible inventory file. You can check if its formatted correctly by
```
ansible-inventory -v --list -i ansible/hosts
```

You can edit 'hosts.tmpl' if you prefer some other format.

## Post install steps
These steps will be manual:
- Reset user password if it expires
- Upgrade VMs with `pacman -Syu`
