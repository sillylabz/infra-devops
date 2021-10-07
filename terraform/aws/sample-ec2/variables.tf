variable "vpc_id" {
  type        = string
}

variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "private_subnet_tags" {
  type        = string
}

# elb vars
variable "elb_healthy_threshold" {
  type        = number
  default = 2
}

variable "elb_unhealthy_threshold" {
  type        = number
  default = 2
}

variable "elb_timeout" {
  type        = number
  default = 3
}

variable "elb_interval" {
  type        = number
  default = 30
}

variable "elb_health_target" {
  type        = string
  default = "TCP:22"
}

# asg vars
variable "asg_ssh_key_name" {
  type        = string
}

variable "asg_max" {
  type        = number
  default = 3
}

variable "asg_min" {
  type        = number
  default = 1
}

variable "asg_grace" {
  type        = number
  default = 300
}

variable "asg_hct" {
  type        = string
  default = "ELB"
}

variable "asg_instance_type" {
  type        = string
}

variable "asg_ami_id" {
  type        = string
}

variable "asg_block_device_mappings" {
  type        = list(map(string))
}

