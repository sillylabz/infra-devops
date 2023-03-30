variable "skip_create_ami" {
  type    = bool
  default = false
}

variable "env" {
  type    = string
}

variable "project_name" {
  type    = string
}

variable "instance_type" {
  type    = string
}

variable "source_ami" {
  type    = string
}

variable "subnet_id" {
  type    = string
}

variable "vpc_id" {
  type    = string
}

variable "communicator" {
  type    = string
}

variable "security_group_id" {
  type    = string
}

variable "tags" {
  type = map(string)
}































