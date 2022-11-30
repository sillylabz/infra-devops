variable "env" {
  type = string
}

variable "app" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "system_masters_users" {
  type = list(any)
}

variable "aws_region" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "aws_account_id" {
  type = string
  default = ""
}

variable "eks_managed_node_groups" {
  type = any
}