terraform {
  required_providers {
    proxmox = {
        source  =   "Telmate/proxmox"
        version =   "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
    pm_api_url      =   "https://192.168.31.3:8006/api2/json"
    pm_user         =   "terraform@pve"
    pm_password     =   "terraform"
    pm_tls_insecure =   true
}

resource    "proxmox_vm_qemu"   "SRV-BACULA-DIRECTOR"   {
    name                    =   "SRV-BACULA-DIRECTOR"
    target_node             =   "pve"
    clone                   =   "debian-12-generic-amd64"
    define_connection_info  =   true
    cpu                     =   "x86-64-v2-AES"
    agent                   =   1
    cores                   =   2
    sockets                 =   2
    memory                  =   2048
    onboot                  =   true
    scsihw                  =   "virtio-scsi-single"
    os_type                 =   "ubuntu"
    # ipconfig0               =   "ip=192.168.31.5/24,gw=192.168.31.1"
    serial  {
        id      =   0
        type    =   "socket"
    }
    disks   {
        scsi    {
            scsi0   {
                disk    {
                    iothread    =   true
                    size        =   8
                    storage     =   "local-lvm"
                }
            }
        }
    }
    network {
        model   =   "virtio"
        bridge  =   "vmbr0"
        tag     =   -1
    }
}