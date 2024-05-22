terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.5"
    }
  }
}

# provider "vsphere" {
#   vsphere_server       = var.vsphere_server_url
#   user                 = var.vsphere_user
#   password             = var.vsphere_password
#   allow_unverified_ssl = true
# }


