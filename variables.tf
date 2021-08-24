#Variables
variable "kmaster_config" {
  description = "kmaster config"
  type = object({
    target_node  = string
    onboot       = bool
    memory       = number
    sockets      = number
    cores        = number
    disk_storage = string
    disk_size    = string
    disk_ssd     = number
  })
  default = {
    target_node  = "pve"
    onboot       = false
    memory       = 8192
    sockets      = 1
    cores        = 4
    disk_storage = "local-lvm"
    disk_size    = "100G"
    disk_ssd     = 1
  }
}

variable "kworker_config" {
  description = "kworker config"
  type = object({
    target_node  = string
    onboot       = bool
    memory       = number
    sockets      = number
    cores        = number
    disk_storage = string
    disk_size    = string
    disk_ssd     = number
  })
  default = {
    target_node  = "pve"
    onboot       = false
    memory       = 4096
    sockets      = 1
    cores        = 2
    disk_storage = "local-lvm"
    disk_size    = "50G"
    disk_ssd     = 1
  }
}

variable "common_configs" {
  description = "Common configs between all nodes"
  type = object({
    clone         = string
    agent         = number
    network_model = string
    disk_type     = string
    nameserver    = string
  })
  default = {
    clone         = "{{CLONE_PATH}}}}"
    agent         = 1
    network_model = "e1000"
    disk_type     = "sata"
    nameserver    = "{{NAME_SERVER}}"
  }
}

variable "kmaster_count" {
  description = "Number of kmaster nodes"
  type        = number
  default     = 1
}

variable "kworker_count" {
  description = "Number of kworker nodes"
  type        = number
  default     = 2
}
