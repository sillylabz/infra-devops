resource "vsphere_tag_category" "tag-categories" {
  for_each = { for idx, category in var.tag_categories : category.name => category }

  name = each.value.name
  cardinality = each.value.cardinality
  description = each.value.description

  associable_types = each.value.associable_types
}

locals {
  category_map = { for k, v in vsphere_tag_category.tag-categories : k => v.id }
}

resource "vsphere_tag" "tags" {
  for_each = { for idx, tag in var.tags : tag.name => tag }

  name = each.value.name
  description = each.value.description
  category_id = local.category_map[each.value.category_name]
}

