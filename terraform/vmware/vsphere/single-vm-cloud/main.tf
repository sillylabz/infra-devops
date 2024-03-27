
resource vsphere_virtual_machine "virtual_machine" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_cpu
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  cdrom {
    client_device = true
  }

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  
  wait_for_guest_net_timeout = 3
  wait_for_guest_net_routable = false

  disk {
    label            = "disk0"
    size             = var.vm_disk_size == null ? data.vsphere_virtual_machine.template.disks.0.size : var.vm_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    timeout = 10
  }
  
  extra_config = {
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/userdata.yml", {
    }))
    "guestinfo.userdata.encoding" = "base64"
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/templates/metadata.yml", {
      hostname = var.vm_name,
      vm_nic_name = var.vm_nic_name,
      vm_ip = var.vm_ipv4_address,
      vm_gateway = var.vm_gateway,
      vm_dns_server = var.vm_dns_server,
      vm_dns_search_domain = var.vm_dns_search_domain,
      vm_disk_extend_size = var.vm_disk_size != null ? tonumber(var.vm_disk_size - tonumber(data.vsphere_virtual_machine.template.disks.0.size)) : tonumber(var.vm_disk_size - tonumber(data.vsphere_virtual_machine.template.disks.0.size))
      
    }))
    "guestinfo.metadata.encoding" = "base64"
  }



}