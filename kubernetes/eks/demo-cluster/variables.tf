variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "demo"
}

variable "create_vpc_endpoints" {
  description = "If true then vpc endpoints for DynamoDB and S3"
  # This allows direct access to these resources from the private subnet, thus reducing nat gateway trafic.
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
  default = [
    {
      rolearn  = "arn:aws:iam::295615438328:role/AWSReservedSSO_EKS_Admins_694a9686a66abdac"
      username = "dev_admin_role"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::107813131109:user/automate"
      username = "demo_admin"
      groups   = ["system:masters"]
    },
  ]
}

// variable "instance_type" {
//   # Smallest recommended, where ~1.1Gb of 2Gb memory is available for the Kubernetes pods after ‘warming up’ Docker, Kubelet, and OS
//   default = "m5.2xlarge"
//   type    = string
// }

variable "tags" {
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only."
  type        = map(string)
  default     = {
    Env  = "dev"
  }
}
