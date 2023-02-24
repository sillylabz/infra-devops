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

variable "vm_datastore" {
  description = "Datastore used for the vSphere virtual machines"
  type = string
}

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

variable "vm_ipv4_address" {
  description = "IP used for the vSphere virtual machines"
  type = string
}

variable "vm_gateway" {
  description = "Gateway ip for the vSphere virtual machine"
  type = string
}

# variable "vm_ip_suffix" {
#   description = "Ip suffix used for the vSphere virtual machines"
#   type = string
# }

variable "vm_disk_size" {
  description = "Disk size in GB for vm disk. Defaults to template disk size"
  type = number
}


variable "vm_dns_server" {
  description = "DNS ip for the vSphere virtual machine"
  type = string
}

variable "vm_cpu" {
  description = "Number of vCPU for the vSphere virtual machines"
  type = number
}

variable "vm_memory" {
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  type = number
}

