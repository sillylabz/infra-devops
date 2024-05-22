# vsphere auth
variable "vsphere_server_url" {
  type        = string
  description = "vSphere server url"
}

variable "vsphere_user" {
  type        = string
  description = "vSphere user"
}

variable "vsphere_password" {
  type        = string
  description = "vSphere user password"
}


# general
variable "tags" {
  description = "vsphere tags to apply to resources"
  type        = list(string)
  default     = []
}

variable "custom_attributes" {
  description = "vsphere custom attributes to apply to resources"
  type        = map(any)
  default     = {}
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
  default     = "lab-datacenter"
}

variable "vsphere_datacenter_folder" {
  description = "Name of folder to host datacenter."
  type        = string
  default     = "dc-folder"
}

variable "create_datacenter_in_folder" {
  description = "toggle to create a folder for the datacenter"
  type        = bool
  default     = true
}

variable "datacenter_parent_folder_name" {
  description = "name of folder to create folder in. Used when var.create_datacenter_in_folder is set to true"
  type        = string
  default     = ""
}


### addtional folders
variable "create_additional_vm_folders" {
  description = "toggle to create additional vm folders in the datacenter"
  type        = bool
  default     = false
}

variable "additional_vm_folder_names" {
  description = "additional vm folders to create in the datacenter"
  type = list(string)
  default = [ "vm-folder1" ]
}



