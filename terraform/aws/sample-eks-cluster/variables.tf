variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "sample"
}

variable "env" {
  default = "dev"
}

variable "vpc_id" {
  default = ""
}

variable "create_vpc_endpoints" {
  description = "If true then vpc endpoints for DynamoDB and S3"
  # This allows direct access to these resources from the private subnet, thus reducing nat gateway traffic.
  type    = bool
  default = true
}

variable "endpoint_private_route_table" {
  type        = list(string)
  default = []
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}


variable "gp_node_group_instance_type" {
  # Smallest recommended, where ~1.1Gb of 2Gb memory is available for the Kubernetes pods after ‘warming up’ Docker, Kubelet, and OS
  default = "m5.2xlarge"
  type    = string
}

variable "gp_node_group_desired_capacity" {
  default = 3
  type    = number
}

variable "gp_node_group_max_capacity" {
  default = 12
  type    = number
}

variable "gp_node_group_min_capacity" {
  default = 3
  type    = number
}

variable "gc_node_group_capacity_type" {
  description = "Instance capacity_type"
  default = "ON_DEMAND"
}

variable "gp_node_group_disk_size" {
  type    = number
  description = "Instance ebs volume size"
  default = 50
}

variable "node_group_root_kms_key_id" {
  type    = string
  description = "KMS key arn used to encrypt/decrypt node EBS volumes."
  default = ""
}

variable "tags" {
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only."
  type        = map(string)
  default     = {
    "SubOwner"    = "Scott Jerome"
    "Cost Center" = "1000"
    Owner         = "Sam Thompson"
    Environment   = "dev"
  }
}
