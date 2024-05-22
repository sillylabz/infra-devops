locals {
  flattened_vm_folders = flatten([
    for folder_set in var.additional_vm_folders : [
      for name in folder_set.names : {
        name = name
        create = folder_set.create
      }
    ]
  ])

  filtered_vm_folders = { for folder in local.flattened_vm_folders : folder.name => folder if folder.create }
}



locals {
  flattened_host_folders = flatten([
    for folder_set in var.additional_host_folders : [
      for name in folder_set.names : {
        name = name
        create = folder_set.create
      }
    ]
  ])

  filtered_host_folders = { for folder in local.flattened_host_folders : folder.name => folder if folder.create }
}


locals {
  flattened_datastore_folders = flatten([
    for folder_set in var.additional_datastore_folders : [
      for name in folder_set.names : {
        name = name
        create = folder_set.create
      }
    ]
  ])

  filtered_datastore_folders = { for folder in local.flattened_datastore_folders : folder.name => folder if folder.create }
}


locals {
  flattened_network_folders = flatten([
    for folder_set in var.additional_network_folders : [
      for name in folder_set.names : {
        name = name
        create = folder_set.create
      }
    ]
  ])

  filtered_network_folders = { for folder in local.flattened_network_folders : folder.name => folder if folder.create }
}


