# esxi host vars
variable "esxi_hostname" {
  description = "esxi hostname or ip"
  type        = string
}

variable "esxi_hostport" {
  description = "esxi host ssh connection port. Should be default 22, or change it it if your configuration is custom."
  type        = string
}

// variable "esxi_hostssl" {
//     description = "esxi host tls secure connection port. Should be default 443, or change it it if your configuration is custom."
//     type = string
// }

variable "esxi_username" {
  description = "esxi host user"
  type        = string
}

variable "esxi_password" {
  description = "esxi host user password"
  type        = string
}


# esxi vm vars
variable "esxi_vm_network" {
  description = "the esxi host network in which to put vm"
  type        = string
}









