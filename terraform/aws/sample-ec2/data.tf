
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_subnet" "subnet_all_lists" {
  for_each = data.aws_subnet_ids.all.ids
  id       = each.value
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = var.private_subnet_tags
  }
}

data "aws_subnet" "subnet_private_lists" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_iam_policy" "asg_ssm_instance_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
}


locals {
  region = "us-east-1"

  tags = [
    {
      key                 = "Name"
      value               = "${var.project_name}-asg-instance"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    Environment = "dev"
  }

}


