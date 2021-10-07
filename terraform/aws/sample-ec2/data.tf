
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc-${var.environment}"]
  }
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
    values = ["${var.project_name}-private-${var.environment}"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-public-${var.environment}"]
  }
}

data "aws_subnet" "subnet_private_lists" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_subnet" "subnet_public_lists" {
  for_each = data.aws_subnet_ids.public.ids
  id       = each.value
}


data "aws_iam_policy" "asg_ssm_instance_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

// data "aws_ami" "amazon_linux" {
//   most_recent = true
//   owners      = ["amazon"]

//   filter {
//     name = "name"

//     values = var.asg_ami_filter_value
//   }
// }


locals {
  s3_logging_bucket_name = "${var.project_name}-${var.application_name}-logging-${var.environment}"
  asg_tags = [
    {
      key                 = "Name"
      value               = "${var.project_name}-${var.application_name}-asg-instance-${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
  ]

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }

}


