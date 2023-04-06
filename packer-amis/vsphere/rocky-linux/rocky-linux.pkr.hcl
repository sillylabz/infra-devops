
locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# vSphere Objects
variable "vcenter_username" {
  type    = string
  description = "The username for authenticating to vCenter."
  default = ""
  sensitive = true
}

variable "vcenter_password" {
  type    = string
  description = "The plaintext password for authenticating to vCenter."
  default = ""
  sensitive = true
}

// variable "vcenter_insecure_connection" {
//   type    = bool
//   description = "If true, does not validate the vCenter server's TLS certificate."
//   default = true
// }

variable "vcenter_server" {
  type    = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  default = ""
}

variable "vcenter_datacenter" {
  type    = string
  description = "Required if there is more than one datacenter in vCenter."
  default = ""
}

variable "vcenter_cluster" {
  type = string
  description = "The cluster where target VM is created."
  default = ""
}

variable "vcenter_datastore" {
  type    = string
  description = "Required for clusters, or if the target host has multiple datastores."
  default = ""
}



variable "vm_name" {
  type    = string
  description = "The template vm name"
  default = ""
}

variable "vm_template_name" {
  type    = string
  description = "The template vm name"
  default = ""
}

variable "vm_cpu_sockets" {
  type = number
  description = "The number of virtual CPUs sockets."
}

variable "vm_cpu_cores" {
  type = number
  description = "The number of virtual CPUs cores per socket."
}

variable "vm_mem_size" {
  type = number
  description = "The size for the virtual memory in MB."
}

variable "thin_provision" {
  type = bool
  description = "Thin or Thick provisioning of the disk"
}

variable "ssh_username" {
  type    = string
  description = "The username to use to authenticate over SSH."
  default = ""
  sensitive = true
}

variable "ssh_password" {
  type    = string
  description = "The plaintext password to use to authenticate over SSH."
  default = ""
  sensitive = true
}


# packer source 
source "vsphere-clone" "rocky-linux" {
    # vcenter creds options
    vcenter_server = var.vcenter_server
    username = var.vcenter_username
    password = var.vcenter_password
    insecure_connection = true
    datacenter = var.vcenter_datacenter
    cluster = var.vcenter_cluster
    datastore = var.vcenter_datastore

    # vm options
    communicator = "ssh"
    vm_name = var.vm_name
    template = var.vm_template_name
    tools_upgrade_policy = true
    convert_to_template = true
    notes = "Built by HashiCorp Packer on ${local.timestamp}."

    # vm cpu options
    CPUs = var.vm_cpu_sockets
    cpu_cores = var.vm_cpu_cores
    CPU_hot_plug = true

    # vm memory options
    RAM = var.vm_mem_size
    RAM_hot_plug = true

    # ssh options
    ssh_password = var.ssh_password
    ssh_username = var.ssh_username
    ssh_clear_authorized_keys = true
    ssh_port = 22
    ssh_timeout = "30m"
}

# packer build 
build {
  sources = [
    "source.vsphere-clone.rocky-linux"
    ]

  provisioner "shell" {
    scripts = [
        "${path.root}/setup.sh"
    ]
    expect_disconnect = true
  }
}

