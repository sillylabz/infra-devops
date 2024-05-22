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


# tag categories
variable "tag_categories" {
  description = "List of tag categories to create"
  type = list(object({
    name             = string
    cardinality      = string
    description      = string
    associable_types = list(string)
  }))
}

# tags

variable "tags" {
  description = "List of tags to create"
  type = list(object({
    name          = string
    category_name = string
    description   = string
  }))
}

