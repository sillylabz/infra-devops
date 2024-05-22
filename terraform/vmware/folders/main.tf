data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter_name
}


# vm folders
resource "vsphere_folder" "vm_folder" {
  for_each = local.filtered_vm_folders

  path          = var.parent_folder == "" ? each.key : "${var.parent_folder}/${each.key}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
  tags = try(var.tags, [])
  custom_attributes = try(var.custom_attributes, {})
}


# host folders
resource "vsphere_folder" "host_folder" {
  for_each = local.filtered_host_folders

  path          = var.parent_folder == "" ? each.key : "${var.parent_folder}/${each.key}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
  tags = try(var.tags, [])
  custom_attributes = try(var.custom_attributes, {})
}


# datastore folders
resource "vsphere_folder" "datastore_folder" {
  for_each = local.filtered_datastore_folders

  path          = var.parent_folder == "" ? each.key : "${var.parent_folder}/${each.key}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
  tags = try(var.tags, [])
  custom_attributes = try(var.custom_attributes, {})
}


# network folders
resource "vsphere_folder" "network_folder" {
  for_each = local.filtered_network_folders

  path          = var.parent_folder == "" ? each.key : "${var.parent_folder}/${each.key}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
  tags = try(var.tags, [])
  custom_attributes = try(var.custom_attributes, {})
}


