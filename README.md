﻿# terraform-k8s-template

Template for setting up VMs for a new cluster in a Proxmox box.

This repo is using the telmate/proxmox provider for terraform.

Make sure to read the [documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) to understand all the variables being used in the variables.tf file

## Important variables to update

In the main.tf file :
- IP_ADDRESS_PROXMOX: This is the IP address of your proxmox box.
- PROXMOX_USERNAME: The username which you want terraform to use
- PROXMOX_PASSWORD: Password for the user mentioned above


In the variables.tf file:
- ISO_PATH: Path used for looking up the ISO in your proxmox server. Format: 'local:iso/Arch_Linux.iso'

**This iso should be present before proceed further**

If we take the format provided as an example, your iso should be located in the 'local' storage in proxmox, under the 'ISO Images' section and should be named 'Arch_Linux.iso'

## Extra configs
There are some params that are not mentioned in the docs. Look [here](https://github.com/Telmate/terraform-provider-proxmox/blob/master/proxmox/resource_vm_qemu.go) to learn more.

One of the params that we're using is 'guest_agent_ready_timeout', its been set to '60' as it speeds up the creation of VMs this way. Look at this [ticket](https://github.com/Telmate/terraform-provider-proxmox/issues/325) to learn more.

## Create the VMs
```
terraform init
# Make sure the config looks good
terraform plan
terraform apply
```
