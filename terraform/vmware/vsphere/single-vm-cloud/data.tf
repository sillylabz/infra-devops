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

// data "vsphere_datastore_cluster" "datastore_cluster" {
//   name          = var.vm_datastore_cluster
//   datacenter_id = data.vsphere_datacenter.dc.id
// }

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}


# data "template_file" "script" {
#   template = "${file("${path.module}/templates/userdata.yaml")}"

#   vars = {}
# }

# data "template_cloudinit_config" "server_config" {
#   gzip          = true
#   base64_encode = true
#   part {
#     content_type = "text/cloud-config"
#     content = data.template_file.script.rendered
#   }
# }
