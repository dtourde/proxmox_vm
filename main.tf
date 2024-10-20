resource "proxmox_vm_qemu" "this" {
  name        = var.name
  target_node = var.target_node

  clone = var.pve_template_name

  agent   = var.enable_qemu_agent ? 1 : 0
  os_type = "cloud-init"
  qemu_os = var.qemu_os
  onboot  = var.onboot

  cores = var.cores
  # cpu                     = "host"
  memory  = var.memory
  scsihw  = "virtio-scsi-single"
  sshkeys = var.sshkeys

  disks {
    scsi {
      scsi0 {
        disk {
          size     = var.disk_size
          storage  = var.storage_pool
          iothread = true
        }
      }
      scsi1 {
        cloudinit {
          storage = var.storage_pool
        }
      }
    }
  }

  # Serial interface of type socket is used by xterm.js
  # You will need to configure your guest system before being able to use it
  serial {
    id   = 0
    type = "socket"
  }

  network {
    model  = "virtio"
    bridge = var.network_bridge
  }
  nameserver = var.nameserver

  ipconfig0 = var.ipconfig0

  lifecycle {
    ignore_changes = [vcpus, clone]
  }
}
