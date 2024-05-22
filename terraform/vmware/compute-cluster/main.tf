data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter_name
}


# add the hosts to vcenter
resource "vsphere_folder" "vm_folder" {
  for_each = local.filtered_vm_folders

  path          = var.parent_folder == "" ? each.key : "${var.parent_folder}/${each.key}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
  tags = try(var.tags, [])
  custom_attributes = try(var.custom_attributes, {})
}




