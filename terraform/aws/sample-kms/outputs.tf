# webdevops key arn
output "sample_kms_key_arn" {
  value = module.sample_kms_key.key_arn
}

output "sample_kms_key_id" {
  value = module.sample_kms_key.key_id
}

output "sample_kms_key_alias_name" {
  value = module.sample_kms_key.alias_name
}


