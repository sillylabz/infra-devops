
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
    "guestinfo.userdata"          = var.vm_os_family == "Fedora" ? local.fedora_userdata : base64encode(templatefile("${path.module}/templates/debian-userdata.yml", {}))
    "guestinfo.userdata.encoding" = "base64"
    "guestinfo.metadata"          = var.vm_os_family == "Fedora" ? base64encode(templatefile("${path.module}/templates/fedora-metadata.yml", {})) : local.debian_metadata
    "guestinfo.metadata.encoding" = "base64"
  }
}


