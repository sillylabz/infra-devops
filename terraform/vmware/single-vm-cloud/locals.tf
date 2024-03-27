locals {
  debian_metadata = base64encode(templatefile("${path.module}/templates/debian-metadata.yml", {
      hostname = var.vm_name,
      vm_nic_name = var.vm_nic_name,
      vm_ip = var.vm_ipv4_address,
      vm_gateway = var.vm_gateway,
      vm_dns_server = var.vm_dns_server,
      vm_dns_search_domain = var.vm_dns_search_domain,
      vm_disk_extend_size = var.vm_disk_size != null ? tonumber(var.vm_disk_size - tonumber(data.vsphere_virtual_machine.template.disks.0.size)) : tonumber(var.vm_disk_size - tonumber(data.vsphere_virtual_machine.template.disks.0.size))
      
    }))

  fedora_userdata = base64encode(templatefile("${path.module}/templates/fedora-userdata.yml", {
      hostname = var.vm_name,
      vm_nic_name = var.vm_nic_name,
      vm_ip = var.vm_ipv4_address,
      vm_gateway = var.vm_gateway,
      vm_dns_server = var.vm_dns_server
    }))
}