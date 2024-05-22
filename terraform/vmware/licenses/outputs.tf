output "license_ids" {
  description = "IDs of the created licenses"
  value       = { for k, v in vsphere_license.licenses : k => v.id }
}
