# proxmox-terraform-template-k8s
 
 [![Terraform](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml/badge.svg)](https://github.com/Naman1997/terraform-k8s-template/actions/workflows/terraform.yml)

Template for setting up VMs for a k8s cluster on a Proxmox node.

Also creates a handy ansible inventory in ansible/hosts.

This repo is using the telmate/proxmox provider for terraform.

Make sure to read the [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) to understand all the variables being used in the variables.tf file

## Important variables to update

All mandatory variables are put in a file named 'terraform.tfvars'.
You can make this file by copying terraform.tfvars.example and updating the values in it.
```
cp terraform.tfvars.example terraform.tfvars
# Edit this file and save it
vim terraform.tfvars
```
Description for all vars in terraform.tfvars is available in 'variables.tf' file
Apart from the variables mentioned above you can also edit other variables in 'variables.tf' file.

The variables mentioned below are hard-coded in main.tf as I don't think most people would move away from these defaults. Please update main.tf if you need other defaults.

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

**CLONE_TEMPLATE should be configured before creating the VMs**

Learn more about how to create a template [here](https://pve.proxmox.com/wiki/VM_Templates_and_Clones#Create_VM_Template)

You can also follow one of the guides below to create a template VM:
- My [repo](https://github.com/Naman1997/arch-cloud-image) for setting up an arch cloud image
- Telmate's [ISO builder](https://github.com/Telmate/terraform-ubuntu-proxmox-iso)

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

You can update 'hosts.tmpl' if you prefer some other format for your ansible inventory.

## Terraform Graph
![alt text](https://raw.githubusercontent.com/Naman1997/proxmox-terraform-template-k8s/main/Graph.JPG)
