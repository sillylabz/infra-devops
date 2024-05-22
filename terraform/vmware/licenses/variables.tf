# vsphere auth
variable "vsphere_server_url" {
  type        = string
  description = "vSphere server url"
  default     = ""
}

variable "vsphere_user" {
  type        = string
  description = "vSphere user"
  default     = ""
}

variable "vsphere_password" {
  type        = string
  description = "vSphere user password"
  default     = ""
}


# licenses
variable "licenses" {
  description = "List of licenses to create"
  type = list(object({
    license_key = string
    labels      = map(string)
  }))
}