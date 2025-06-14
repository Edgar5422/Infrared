packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

source "vmware-iso" "ubuntu" {
  iso_url            = "D:/DESCARGAS/edgar.diaz/Descargas/ubuntu-24.04.1-live-server-amd64.iso"
  iso_checksum       = "SHA256:E240E4B801F7BB68C20D1356B60968AD0C33A41D00D828E74CEB3364A0317BE9"

  communicator       = "ssh"
  ssh_username       = "ubuntu"
  ssh_password       = "ubuntu"
  ssh_timeout        = "20m"

  shutdown_command   = "echo 'ubuntu' | sudo -S shutdown -P now"

  vm_name            = "ubuntu24-template"
  guest_os_type      = "ubuntu-64"

  disk_size          = 10240
  memory             = 2048
  cpus               = 2

  boot_command = [
    "<esc><wait>",
    "<enter><wait>",
  ]

  headless = false
}

build {
  sources = ["source.vmware-iso.ubuntu"]
}


