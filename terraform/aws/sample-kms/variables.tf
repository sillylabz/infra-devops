variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "Cost Center" = "1000"
    Owner         = "Sam Thompson"
    Environment   = "DEV"
  }
}

variable "aws_admin_role_arn" {
  description = "Admin role to allow access to created KMS."
  type        = list(string)
  default     = []
}

variable "user_role_arn" {
  description = "User role to allow access to created KMS."
  type        = list(string)
  default     = []
}

variable "project_name" {
  description = "Project name to prefix resources."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Preoject environment. e.g dev, qa, prod"
  type        = string
  default     = ""
}









