locals {
  additional_vm_folders = [{
    create = var.create_additional_vm_folders
    names = var.additional_vm_folder_names 
  }]
}
