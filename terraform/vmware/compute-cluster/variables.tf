# vsphere auth
variable "vsphere_server_url" {
  type        = string
  description = "vSphere server url"
  default = ""
}

variable "vsphere_user" {
  type        = string
  description = "vSphere user"
  default = ""
}

variable "vsphere_password" {
  type        = string
  description = "vSphere user password"
  default = ""
}


# general
variable "tags" {
  description = "vsphere tags to apply to resources"
  type        = list(string)
  default = []
}

variable "custom_attributes" {
  description = "vsphere custom attributes to apply to resources"
  type        = map(any)
  default = {}
}

variable "parent_folder" {
  description = "parent folder to create vm folder in."
  type        = string
  default = ""
}

# datacenter 
variable "vsphere_datacenter_name" {
  description = "Name of datacenter to create in vcenter server"
  type        = string
  default = "lab-datacenter"
}


### vm folders
variable "additional_vm_folders" {
  description = "additional vm folders to create in the datacenter"
  type = list(object({
    names   = set(string)
    create = bool
  }))
  default = [{
    create = false
    names = [
      "vm-folder-1",
      "vm-folder-2",
      "vm-folder-3"
    ]
  }]
}


### host folders
variable "additional_host_folders" {
  description = "additional host folders to create in the datacenter"
  type = list(object({
    names   = set(string)
    create = bool
  }))
  default = [{
    create = false
    names = [
      "host-folder-1",
      "host-folder-2",
      "host-folder-3"
    ]
  }]
}

### datastore folders
variable "additional_datastore_folders" {
  description = "additional datastore folders to create in the datacenter"
  type = list(object({
    names   = set(string)
    create = bool
  }))
  default = [{
    create = false
    names = [
      "datastore-folder-1",
      "datastore-folder-2",
      "datastore-folder-3"
    ]
  }]
}


### network folders
variable "additional_network_folders" {
  description = "additional network folders to create in the datacenter"
  type = list(object({
    names   = set(string)
    create = bool
  }))
  default = [{
    create = false
    names = [
      "network-folder-1",
      "network-folder-2",
      "network-folder-3"
    ]
  }]
}


