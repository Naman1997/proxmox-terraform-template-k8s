# proxmox-terraform-template-k8s
 
 [![Terraform](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml/badge.svg)](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml)
 [![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/Naman1997/proxmox-terraform-template-k8s/blob/main/LICENSE)

## Objective of this repo

To create a template terraform script that is able to create VMs for a k8s cluster along with an optional VM for NFS. The script also outputs a handy ansible inventory in './ansible/hosts' that can be used to run ansible playbooks after terraform is done creating the VMs.

This repo is using the telmate/proxmox provider for terraform. Refer to the [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) to understand all the variables being used in the 'variables.tf' file.

## Prerequisite

You need to create a proxmox template for the cloning process. Learn more about proxmox templates [here](https://pve.proxmox.com/wiki/VM_Templates_and_Clones#Create_VM_Template).

If you don't need any modifications on top of your base image, then you can create a new VM that uses an official cloud image from [ubuntu](https://cloud-images.ubuntu.com/), [arch](https://wiki.archlinux.org/title/Arch_Linux_on_a_VPS#Official_Arch_Linux_cloud_image), etc and use that VM as a template.

You can also follow one of the guides below to create a modified template:
- My [repo](https://github.com/Naman1997/arch-cloud-image) for setting up a modified arch linux cloud image using packer
- Telmate's [ISO builder](https://github.com/Telmate/terraform-ubuntu-proxmox-iso)

Once this template is ready, the name of the template should go in variable 'CLONE_TEMPLATE' in 'terraform.tfvars' file.

## Important variables to update

All mandatory variables are put in a file named 'terraform.tfvars'.
You can create this file by copying the file 'terraform.tfvars.example' and updating it.
```
cp terraform.tfvars.example terraform.tfvars
# Edit this file and save it
# Make sure to update CLONE_TEMPLATE as discussed in the previous section
vim terraform.tfvars
```
Description for all vars in file 'terraform.tfvars' is available in file 'variables.tf'.
Apart from the variables mentioned above you can also edit other variables in file 'variables.tf'.

The variables mentioned below are hard-coded in file 'main.tf' as I don't think most people would move away from these defaults. Please update file 'main.tf' if you need different defaults.

```
<!-- Proxmox TLS check -->
pm_tls_insecure = true
<!-- Full cloning for all VMs -->
full_clone = true
<!-- SSH port for all VMs -->
ansible_port = 22
```

## Create the VMs
```
terraform init
# Make sure the config looks good
terraform plan
terraform apply
```

This will also create an ansible inventory file in './ansible/hosts'.

## Deploy k8s on VMs running arch linux [Optional]
If you decided to use arch linux as your OS for these VMs, then check out [cluster-management](https://github.com/Naman1997/cluster-management). This repo is a collection of playbooks that can deploy a k8s cluster on top of VMs running arch linux.

## Terraform Graph
![alt text](https://raw.githubusercontent.com/Naman1997/proxmox-terraform-template-k8s/main/Graph.JPG)
