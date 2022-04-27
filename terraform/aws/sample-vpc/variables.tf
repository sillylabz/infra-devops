variable "aws_region" {}
data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}

variable "subnet_cidrs" {
  type = map(any)
}

variable "project_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "environment" {
  type = string
}

