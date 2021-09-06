terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.PROXMOX_API_ENDPOINT
  pm_user         = var.PROXMOX_USERNAME
  pm_password     = var.PROXMOX_PASSWORD
  pm_tls_insecure = true
}

# Setting up kmaster nodes
resource "proxmox_vm_qemu" "kmaster" {
  count                     = var.kmaster_config.count
  name                      = format("kmaster%s", count.index)
  desc                      = "Master node in k8s cluster."
  os_type                   = "cloud-init"
  clone                     = var.CLONE_TEMPLATE
  full_clone                = true
  agent                     = var.common_configs.agent
  target_node               = var.PROXMOX_NODE
  onboot                    = var.kmaster_config.onboot
  memory                    = var.kmaster_config.memory
  sockets                   = var.kmaster_config.sockets
  cores                     = var.kmaster_config.cores
  guest_agent_ready_timeout = 60
  nameserver                = var.NAMESERVER
  boot                      = var.BOOT_ORDER

  network {
    model  = var.common_configs.network_model
    bridge = var.DEFAULT_BRIDGE
  }

}

# Setting up kworker nodes
resource "proxmox_vm_qemu" "kworker" {
  count                     = var.kworker_config.count
  name                      = format("kworker%s", count.index)
  desc                      = "Worker node in k8s cluster."
  os_type                   = "cloud-init"
  clone                     = var.CLONE_TEMPLATE
  full_clone                = true
  agent                     = var.common_configs.agent
  target_node               = var.PROXMOX_NODE
  onboot                    = var.kworker_config.onboot
  memory                    = var.kworker_config.memory
  sockets                   = var.kworker_config.sockets
  cores                     = var.kworker_config.cores
  guest_agent_ready_timeout = 60
  nameserver                = var.NAMESERVER
  boot                      = var.BOOT_ORDER

  network {
    model  = var.common_configs.network_model
    bridge = var.DEFAULT_BRIDGE
  }

}

resource "proxmox_vm_qemu" "nfs" {
  count                     = var.NFS_ENABLE ? 1 : 0
  name                      = "nfs-server"
  desc                      = "NFS node in k8s cluster."
  os_type                   = "cloud-init"
  clone                     = var.CLONE_TEMPLATE
  full_clone                = true
  agent                     = var.common_configs.agent
  target_node               = var.PROXMOX_NODE
  onboot                    = var.nfs_config.onboot
  memory                    = var.nfs_config.memory
  sockets                   = var.nfs_config.sockets
  cores                     = var.nfs_config.cores
  guest_agent_ready_timeout = 60
  nameserver                = var.NAMESERVER
  boot                      = var.BOOT_ORDER

  network {
    model  = var.common_configs.network_model
    bridge = var.DEFAULT_BRIDGE
  }

  disk {
    type    = var.nfs_config.disk_type
    storage = var.nfs_config.disk_storage
    size    = var.nfs_config.disk_size
  }

}

resource "local_file" "ansible_hosts" {

  depends_on = [
    proxmox_vm_qemu.kworker,
    proxmox_vm_qemu.kmaster
  ]

  content = templatefile("hosts.tmpl",
    {
      node_map_masters = zipmap(
        tolist(proxmox_vm_qemu.kmaster.*.ssh_host), tolist(proxmox_vm_qemu.kmaster.*.name)
      ),
      node_map_workers = zipmap(
        tolist(proxmox_vm_qemu.kworker.*.ssh_host), tolist(proxmox_vm_qemu.kworker.*.name)
      ),
      node_map_nfs = zipmap(
        tolist(proxmox_vm_qemu.nfs.*.ssh_host), tolist(proxmox_vm_qemu.nfs.*.name)
      ),
      "ansible_port" = 22,
      "ansible_user" = var.TEMPLATE_USERNAME
    }
  )
  filename = "${path.module}/ansible/hosts"

}

output "ansible_inventory" {
  depends_on = [
    local_file.ansible_hosts
  ]
  value = local_file.ansible_hosts.content
}
