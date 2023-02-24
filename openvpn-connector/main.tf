terraform {
  backend "local" {}
}


module "vm" {
  source = "git::https://github.com/hernanku/infra-devops.git//terraform/vmware/vsphere/single-vm-cloud"
  vsphere_server_url = "10.0.0.31"
  vsphere_user       = "administrator@vsphere.local"
  vsphere_password   = "PrankWe66#"
  vsphere_datacenter = "dc-east"
  vsphere_cluster    = "dev-cluster"
  vm_datastore = "vmData"
  vm_name            = "openvpn-connector"
  vm_disk_size = 30
  vm_domain = "labz.io"
  vm_ipv4_address = "10.0.0.27"
  vm_gateway = "10.0.0.1"
  vm_dns_server = "10.0.0.33"
  // vm_count = 1
  vm_network     = "vmPub"
  vm_template    = "base-ubuntu22-templ"
  vm_cpu         = 1
  vm_memory      = 2048
}

