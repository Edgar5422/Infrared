variable "vsphere_user" {
  type = string
}

variable "vsphere_password" {
  type = string
  sensitive = true
}

variable "vsphere_server" {
  type = string
}
