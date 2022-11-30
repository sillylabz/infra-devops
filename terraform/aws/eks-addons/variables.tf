variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name to create irsa's and deploy k8s services via helm."
  type        = string
}

variable "cluster_kms_key_alias" {
  description = "KMS key for encrypting data in EFS."
}

variable "app" {
  description = "Application name."
  type        = string
}

variable "env" {
  description = "Project Environment."
  type        = string
}

variable "tier" {
  description = "Project Cost Center"
  type        = string
}

## ebs csi vars
variable "ebs_controller_image_version" {
  description = "ebs csi controller image version"
  type = string
}



## datadog vars
variable "datadog_api_key" {
  description = "datadog api key"
  type = string
}

# variable "splunk_hec_token" {
#   description = "Splunk HEC token for logs"
#   type        = string
# }

# variable "splunk_metrics_hec_token" {
#   description = "HEC token for sending metrics data to Splunk. HEC token must exist."
#   type        = string
# }

# variable "splunk_index" {
#   description = "Splunk index for forwarding logs. Index must exist"
#   type        = string
# }

# variable "splunk_metric_index" {
#   description = "Splunk index for forwarding metric data. Index must exist"
#   type        = string
# }

# # velero vars
# variable "velero_user_aws_access_key" {
#   description = "Velero user access key"
#   type        = string
# }

# variable "velero_user_aws_secret_access_key" {
#   description = "Velero user secret access key"
#   type        = string
# }

# variable "velero_backup_location_name" {
#   description = "Velero backup location name"
#   type        = string
# }

# variable "velero_backup_snapshot_name" {
#   description = "Velero backup snapshot name"
#   type        = string
# }










