variable "vsphere_server_url" {
  description = "vSphere server url"
}

variable "vsphere_user" {
  description = "vSphere user"
}

variable "vsphere_password" {
  description = "vSphere user password"
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  type = string
}

variable "vm_name" {
  description = "The name of the vSphere virtual machines and the hostname of the machine"
  type = string
}

// variable "vm_count" {
//   description = "Number of vSphere virtual machines to be created"
//   type = number
// }

variable "vm_datastore" {
  description = "Datastore used for the vSphere virtual machines"
  type = string
}

// variable "vm_datastore_cluster" {
//   description = "Datastore cluster used for the vSphere virtual machines"
//   type = string
// }

variable "vm_network" {
  description = "Network used for the vSphere virtual machines"
  type = string
}

variable "vm_domain" {
  description = "Domain for the vSphere virtual machine"
  type = string
}

variable "vm_template" {
  description = "Template used to create the vSphere virtual machines"
  type = string
}

variable "vm_linked_clone" {
  description = "Use linked clone to create the vSphere virtual machine from the template (true/false). If you would like to use the linked clone feature, your template need to have one and only one snapshot"
  type = bool
  default     = false
}

variable "vm_baseip" {
  description = "Base IP used for the vSphere virtual machines"
  type = string
}

variable "vm_ip_suffix" {
  description = "Ip suffix used for the vSphere virtual machines"
  type = string
}

variable "vm_netmask" {
  description = "Netmask used for the vSphere virtual machine (example: 24)"
  type = number
}

variable "vm_gateway" {
  description = "Gateway ip for the vSphere virtual machine"
  type = string
}

variable "vm_dns_servers" {
  description = "DNS ip for the vSphere virtual machine"
  type = list(string)
}

variable "vm_cpu" {
  description = "Number of vCPU for the vSphere virtual machines"
  type = number
}

variable "vm_memory" {
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  type = number
}

