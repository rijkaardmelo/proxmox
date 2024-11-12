variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcwZAOfqf6E6p8IkrurF2vR3NccPbMlXFPaFe2+Eh/8QnQCJVTL6PKduXjXynuLziC9cubXIDzQA+4OpFYUV2u0fAkXLOXRIwgEmOrnsGAqJTqIsMC3XwGRhR9M84c4XPAX5sYpOsvZX/qwFE95GAdExCUkS3H39rpmSCnZG9AY4nPsVRlIIDP+/6YSy9KWp2YVYe5bDaMKRtwKSq3EOUhl3Mm8Ykzd35Z0Cysgm2hR2poN+EB7GD67fyi+6ohpdJHVhinHi7cQI4DUp+37nVZG4ofYFL9yRdULlHcFa9MocESvFVlVW0FCvwFKXDty6askpg9yf4FnM0OSbhgqXzD root@192.168.31.2"
}

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
    target_node             =   "proxmox"
    clone                   =   "debian-12-generic-amd64"
    define_connection_info  =   true
    cpu                     =   "x86-64-v2-AES"
    agent                   =   1
    cores                   =   2
    sockets                 =   2
    memory                  =   2048
    onboot                  =   true
    scsihw                  =   "virtio-scsi-single"
    serial  {
        id      =   0
        type    =   "socket"
    }
    disks   {
        scsi    {
            scsi0   {
                disk    {
                    iothread    =   true
                    size        =   32
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
    ipconfig0 = "ip=192.168.31.4/24,gw=192.168.1.1"
    sshkeys = <<EOF
    ${var.ssh_key}
    EOF 
}