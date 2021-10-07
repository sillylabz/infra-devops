
variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "application_name" {
  type = string
}

variable "environment" {
  type = string
}

# elb vars
variable "asg_elb_listeners" {
  type = list(map(string))
}

variable "asg_elb_health_check" {
  type = map(string)
}


# asg vars
variable "asg_ssh_key_name" {
  type = string
}

variable "asg_max" {
  type    = number
  default = 3
}

variable "asg_min" {
  type    = number
  default = 1
}

variable "asg_grace" {
  type    = number
  default = 300
}

variable "asg_health_check_type" {
  type = string
}

variable "asg_instance_type" {
  type = string
}

// variable "asg_ami_filter_value" {
//   type = list(string)
// }

variable "asg_ami_id" {
  type = string
}

variable "asg_block_device_mappings" {
  type = list(any)
}

