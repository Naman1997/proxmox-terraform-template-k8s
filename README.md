# proxmox-terraform-template-k8s
 
 [![Terraform](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml/badge.svg)](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml)

## Objective of this repo

To create a template terraform script that is able to create VMs for a k8s cluster along with an optional VM for NFS. The script also outputs a handy ansible inventory in 'ansible/hosts' that the user can use to run ansible playbooks after terraform is done creating the VMs.

This repo is using the telmate/proxmox provider for terraform.Refer the [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) to understand all the variables being used in the variables.tf file.

## Prerequisite

You need to create a template VM for the cloning process. Learn more about how to create a template [here](https://pve.proxmox.com/wiki/VM_Templates_and_Clones#Create_VM_Template).

If you don't need any modifications on top of your base image, then you can create a new VM that uses an official cloud image from [ubuntu](https://cloud-images.ubuntu.com/), [arch](https://wiki.archlinux.org/title/Arch_Linux_on_a_VPS#Official_Arch_Linux_cloud_image), etc and use that VM as a template.

You can also follow one of the guides below to create a template VM:
- My [repo](https://github.com/Naman1997/arch-cloud-image) for setting up a modified arch linux cloud image using packer
- Telmate's [ISO builder](https://github.com/Telmate/terraform-ubuntu-proxmox-iso)

Once this template is ready, the name of the VM should go in variable CLONE_TEMPLATE in 'terraform.tfvars' file.

## Important variables to update

All mandatory variables are put in a file named 'terraform.tfvars'.
You can make this file by copying terraform.tfvars.example and updating the values in it.
```
cp terraform.tfvars.example terraform.tfvars
# Edit this file and save it
# Make sure to update CLONE_TEMPLATE as discussed in the previous section
vim terraform.tfvars
```
Description for all vars in terraform.tfvars is available in 'variables.tf' file.
Apart from the variables mentioned above you can also edit other variables in 'variables.tf' file.

The variables mentioned below are hard-coded in main.tf as I don't think most people would move away from these defaults. Please update main.tf if you need other defaults.

```
<!-- Proxmox TLS check -->
pm_tls_insecure = true
<!-- Full cloning for all VMs -->
full_clone = true
<!-- SSH port for all VMs -->
ansible_port = 22
```

The ansible inventory follows a template that is provided in file 'hosts.tmpl'. You can update that template if you prefer some other format for your ansible inventory.

## Create the VMs
```
terraform init
# Make sure the config looks good
terraform plan
terraform apply
```

This will also create an ansible inventory file in './ansible/hosts'.

## Terraform Graph
![alt text](https://raw.githubusercontent.com/Naman1997/proxmox-terraform-template-k8s/main/Graph.JPG)
