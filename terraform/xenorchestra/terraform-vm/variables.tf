


variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "xen_host_url" {
  description = "Must be ws or wss"
  type        = string
}

variable "xen_username" {
  type = string
}

variable "xen_password" {
  type = string
}

variable "xen_sr_name" {
  type = string
}

variable "xen_pool" {
  type = string
}

variable "xen_sr_id" {
  type = string
}

variable "xen_network_id" {
  type = string
}

variable "xen_cloud_config_name" {
  type = string
}

variable "vm_template_name" {
  type = string
}

variable "vm_disk_size_in_bytes" {
  type = number
}

variable "vm_cpus" {
  type = number
}

variable "vm_memory_max" {
  type = number
}










