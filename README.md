# proxmox_vm

This module suits my own needs, if you need to use it, you will have to make some modifications, particularily on the variable validation side.

# Usage

Usage exemple to create multiple instances.

```
# variables.tf
variable "k3s_server" {
  description = "K3S server instances"
  type = map(object({
    cores     = optional(number, 2)
    memory    = optional(number, 2 * 1024)
    disk_size = optional(string, "30G")
    ip        = string
    gw        = string
  }))
}


variable "sshkeys" {
  description = "ssh keys to add to the instance"
  type        = string
  default     = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOIkoUOXUo+P0d3vgGL53k00xDICqmzKgCnwDHk4F9X example@dtourde
EOF
}

# vars.tfvars
k3s_server = {
  0 = {
    ip = "10.0.11.30/24"
    gw = "10.0.11.1"
  }
  1 = {
    ip = "10.0.11.31/24"
    gw = "10.0.11.1"
  }
  2 = {
    ip = "10.0.11.32/24"
    gw = "10.0.11.1"
  }
}

# main.tf
module "k3s_server" {
  for_each = var.k3s_server
  source   = "../modules/proxmox_vm"

  name = format("server-%s", each.key)

  network_bridge = "vmbr11"
  ipconfig0  = format("ip=%s,gw=%s", each.value.ip, each.value.gw)
  nameserver = "10.0.11.1"

  cores     = each.value.cores
  memory    = each.value.memory
  disk_size = each.value.disk_size

  sshkeys = var.sshkeys
}
```

# TODO

* add option to start vm with hyperviser

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 3.0.1-rc4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 3.0.1-rc4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_vm_qemu.this](https://registry.terraform.io/providers/telmate/proxmox/3.0.1-rc4/docs/resources/vm_qemu) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cores"></a> [cores](#input\_cores) | number of cores for a vm | `number` | `1` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | root disk size with unit (e.g. 8G) | `string` | `"4G"` | no |
| <a name="input_enable_qemu_agent"></a> [enable\_qemu\_agent](#input\_enable\_qemu\_agent) | Tells PVE that the VM have qemu agent installed | `bool` | `true` | no |
| <a name="input_ipconfig0"></a> [ipconfig0](#input\_ipconfig0) | Network configuration to pass to the cloud init | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | size of the allocated memory in MB | `number` | `256` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the vm to create | `string` | n/a | yes |
| <a name="input_nameserver"></a> [nameserver](#input\_nameserver) | Sets default DNS server for guest. | `string` | n/a | yes |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge) | network bridge to bridge the vm to | `string` | `"vmbr11"` | no |
| <a name="input_onboot"></a> [onboot](#input\_onboot) | Whether to have the VM startup after the PVE node starts. | `bool` | `true` | no |
| <a name="input_pve_template_name"></a> [pve\_template\_name](#input\_pve\_template\_name) | Name of the pve template to create VM | `string` | `"debian12-std"` | no |
| <a name="input_qemu_os"></a> [qemu\_os](#input\_qemu\_os) | Kind of QEMU\_OS, l26 for Linux >2.6 | `string` | `"l26"` | no |
| <a name="input_sshkeys"></a> [sshkeys](#input\_sshkeys) | ssh keys to add to the instance | `string` | n/a | yes |
| <a name="input_storage_pool"></a> [storage\_pool](#input\_storage\_pool) | Storage pool where to create the VM disk | `string` | `"lvm_r1_ssd0"` | no |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | proxmox target node | `string` | `"pve1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
