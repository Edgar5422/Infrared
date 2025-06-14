terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.12.0"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}


data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "SVR1_OS"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = "192.168.0.3"  # O 0.5 o 0.7 si quieres usar otro host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "from_packer_disk" {
  name             = "infrared-from-disk"
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label         = "infrared-os-disk"
    path          = "[SVR1_OS] ISOS/ubuntu24-template.vmdk"  # Cambia si es otro nombre
    datastore_id  = data.vsphere_datastore.datastore.id
    attach        = true
    unit_number   = 0
  }


  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "[SVR1_OS] ISOS/ubuntu-24.04.1-live-server-amd64.iso"  # Opcional
  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
}




