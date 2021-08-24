terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://{{IP_ADDRESS_PROXMOX}}:8006/api2/json"
  pm_user         = "{{PROXMOX_USERNAME}}"
  pm_password     = "{{PROXMOX_PASSWORD}}"
  pm_tls_insecure = true
}

# Setting up kmaster nodes
resource "proxmox_vm_qemu" "kmaster" {
  count                     = var.kmaster_count
  name                      = format("kmaster%s", count.index)
  desc                      = format("Master node in k8s cluster.")
  os_type                   = "cloud-init"
  clone                     = var.common_configs.clone
  full_clone                = true
  agent                     = var.common_configs.agent
  target_node               = var.kmaster_config.target_node
  onboot                    = var.kmaster_config.onboot
  memory                    = var.kmaster_config.memory
  sockets                   = var.kmaster_config.sockets
  cores                     = var.kmaster_config.cores
  guest_agent_ready_timeout = 60

  network {
    model  = var.common_configs.network_model
    bridge = "vmbr0"
  }

  disk {
    type    = var.common_configs.disk_type
    storage = var.kmaster_config.disk_storage
    size    = var.kmaster_config.disk_size
    ssd     = var.kmaster_config.disk_ssd
  }

  nameserver = var.common_configs.nameserver
}

# Setting up kworker nodes
resource "proxmox_vm_qemu" "kworker" {
  count                     = var.kworker_count
  name                      = format("kworker%s", count.index)
  desc                      = format("Worker node in k8s cluster.")
  os_type                   = "cloud-init"
  clone                     = var.common_configs.clone
  full_clone                = true
  agent                     = var.common_configs.agent
  target_node               = var.kworker_config.target_node
  onboot                    = var.kworker_config.onboot
  memory                    = var.kworker_config.memory
  sockets                   = var.kworker_config.sockets
  cores                     = var.kworker_config.cores
  guest_agent_ready_timeout = 60

  network {
    model  = var.common_configs.network_model
    bridge = "vmbr0"
  }

  disk {
    type    = var.common_configs.disk_type
    storage = var.kworker_config.disk_storage
    size    = var.kworker_config.disk_size
    ssd     = var.kworker_config.disk_ssd
  }

  nameserver = var.common_configs.nameserver
}
