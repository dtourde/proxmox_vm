variable "name" {
  description = "Name of the vm to create"
  type        = string
}

variable "target_node" {
  description = "proxmox target node"
  type        = string
  default     = "pve1"
}

variable "pve_template_name" {
  description = "Name of the pve template to create VM"
  type        = string
  default     = "debian12-std"

  validation {
    condition     = can(regex("^debian12-std$|^ubuntu2204-std$", var.pve_template_name))
    error_message = "The variable must be equal to 'debian12-std' or 'ubuntu2204-std."
  }
}

variable "enable_qemu_agent" {
  description = "Tells PVE that the VM have qemu agent installed"
  type        = bool
  default     = true
}

variable "qemu_os" {
  description = "Kind of QEMU_OS, l26 for Linux >2.6"
  type        = string
  default     = "l26"
}

variable "onboot" {
  description = "Whether to have the VM startup after the PVE node starts."
  type        = bool
  default     = true
}

variable "cores" {
  # https://forum.proxmox.com/threads/sockets-vs-cores-vs-vcpus.56339/
  description = "number of cores for a vm"
  type        = number
  default     = 1
}

variable "memory" {
  description = "size of the allocated memory in MB"
  type        = number
  default     = 256
}

variable "sshkeys" {
  description = "ssh keys to add to the instance"
  type        = string
}

variable "disk_size" {
  description = "root disk size with unit (e.g. 8G)"
  type        = string
  default     = "4G"
}

variable "storage_pool" {
  description = "Storage pool where to create the VM disk"
  type        = string
  default     = "lvm_r1_ssd0"

  validation {
    condition     = can(regex("^lvm_r1_ssd0$", var.storage_pool))
    error_message = "The variable must be equal to 'lvm_r1_ssd0'."
  }
}

variable "network_bridge" {
  description = "network bridge to bridge the vm to"
  type        = string
  default     = "vmbr11"

  validation {
    condition     = can(regex("^vmbr10$|^vmbr11$|^vmbr20$", var.network_bridge))
    error_message = "The variable must be equal to 'vmbr10', 'vmbr11', or 'vmbr20'."
  }
}

variable "ipconfig0" {
  description = "Network configuration to pass to the cloud init"
  type        = string

  validation {
    condition     = can(regex("^ip=\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2},gw=\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", var.ipconfig0))
    error_message = "The variable must have the form 'ip=10.0.10.162/24,gw=10.0.10.1'."
  }
}

variable "nameserver" {
  description = "Sets default DNS server for guest."
  type        = string
}
