variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  description = "Project name, will prefix all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "private_subnets_tag" {
  description = "Private Subnets tag name"
  type        = list(string)
}

variable "public_subnets_tag" {
  description = "Public Subnets tag name"
  type        = list(string)
}

variable "owner" {
  description = "Project Owner for tagging resources"
  type        = string
}

variable "environment" {
  description = "Project environment for tagging resources"
  type        = string
}

variable "cost_center" {
  description = "Project Cost Center for tagging resources"
  type        = string
}

variable "sg_ingress_cidrs" {
  description = "Additional ingress cids for the bastion security group"
  type        = list(string)
  default     = []
}

// variable "access_key" {
//   type = string
//   default = ""
// }

// variable "secret_key" {
//   type = string
//   default = ""
// }

// variable "access_token" {
//   type = string
//   default = ""
// }

// variable "s3_backend_bucket_name" {
//   type = string
//   default = ""
// }

variable "key_name" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "iam_instance_profile" {
  type    = string
  default = ""
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "elb_healthy_threshold" {
  default = 2
}

variable "elb_unhealthy_threshold" {
  default = 2
}

variable "elb_timeout" {
  default = 3
}

variable "elb_interval" {
  default = 30
}

variable "asg_max" {}

variable "asg_min" {}

variable "asg_grace" {
  default = 300
}

variable "asg_hct" {
  type    = string
  default = "ELB"
}

variable "asg_cap" {}


variable "cluster_extra_tags" {
  description = "A list of additional tags to add to each Instance in the ASG. Each element in the list must be a map with the keys key, value, and propagate_at_launch"
  type        = list(object({ key : string, value : string, propagate_at_launch : bool }))
  default = []
}



