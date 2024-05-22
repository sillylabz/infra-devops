resource "vsphere_license" "licenses" {
  for_each    = { for idx, license in var.licenses : license.license_key => license }
  license_key = each.value.license_key

  labels = each.value.labels
}


