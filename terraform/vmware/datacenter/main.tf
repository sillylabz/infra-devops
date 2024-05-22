resource "vsphere_datacenter" "dc" {
  name              = var.vsphere_datacenter_name
  folder            = var.create_datacenter_in_folder && var.vsphere_datacenter_folder == "" ? vsphere_folder.dc-folder[0].path : var.vsphere_datacenter_folder
  tags              = try(var.tags, [])
  custom_attributes = try(var.custom_attributes, {})
  depends_on        = [vsphere_folder.dc-folder]
}

resource "vsphere_folder" "dc-folder" {
  count             = var.create_datacenter_in_folder ? 1 : 0
  path              = var.datacenter_parent_folder_name == "" ? var.vsphere_datacenter_name : var.datacenter_parent_folder_name
  type              = "datacenter"
  tags              = try(var.tags, [])
  custom_attributes = try(var.custom_attributes, {})
}

## additinal datacenter folders

module additinal_datacenter_folders {
  source = "../folders"

  vsphere_datacenter_name = var.vsphere_datacenter_name
  additional_vm_folders = local.additional_vm_folders

  depends_on = [ 
    vsphere_datacenter.dc, 
    vsphere_folder.dc-folder 
    ]
}

