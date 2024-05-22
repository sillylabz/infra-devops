output "tag_category_ids" {
  description = "IDs of the created tag categories"
  value = { for k, v in vsphere_tag_category.tag-categories : k => v.id }
}

output "tag_ids" {
  description = "IDs of the created tags"
  value = { for k, v in vsphere_tag.tags : k => v.id }
}
