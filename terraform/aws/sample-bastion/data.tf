
data "aws_region" "current" {}


data "aws_availability_zones" "available" {
}


data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet" "all_subnet_list" {
  for_each = data.aws_subnet_ids.all.ids
  id = each.value
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.vpc.id

filter {
    name = "tag:Name"
    values = var.private_subnets_tag
  }
}

data "aws_subnet" "private_subnet_list" {
  for_each = data.aws_subnet_ids.private_subnets.ids
  id = each.value
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name = "tag:Name"
    values = var.public_subnets_tag
  }
}

data "aws_subnet" "public_subnet_list" {
  for_each = data.aws_subnet_ids.public_subnets.ids
  id = each.value
}

locals {
  global_tags = {
    Owner       = var.owner
    Environment = var.environment
    "Cost Center" = var.cost_center
  }
}

