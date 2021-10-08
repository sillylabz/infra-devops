
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

variable "subnet_filter_tag" {
  description = "name used to filter subnets used by asg. Options are public, private, and database"
  type        = string
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

variable "min_size" {
}

variable "max_size" {
}

variable "desired_capacity" {
}

variable "health_check_type" {
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

