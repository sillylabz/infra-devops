
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_datastore" "datastore" {
  name          = var.vm_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "virtual_machine" {
  count            = var.vm_count
  name             = "${var.vm_name}${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  firmware = "efi"
  wait_for_guest_net_timeout = 5
  wait_for_guest_ip_timeout = 5
  efi_secure_boot_enabled = false

  num_cpus = var.vm_cpu
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk_size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.vm_linked_clone

    customize {
      timeout = 3

      linux_options {
        host_name = "${var.vm_name}${count.index + 1}"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = "${var.vm_baseip}.${var.vm_ip_suffix + count.index}"
        ipv4_netmask = var.vm_netmask
      }
      ipv4_gateway    = var.vm_gateway
      dns_server_list = var.vm_dns_servers
    }
  }
}
