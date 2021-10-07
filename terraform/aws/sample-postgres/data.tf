
data "aws_region" "current" {}


data "aws_availability_zones" "available" {
}


data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.vpc.id

filter {
    name = "tag:Name"
    values = ["sample-private01", "sample-private02"]
  }
}

data "aws_subnet" "private_subnet_list" {
  for_each = data.aws_subnet_ids.private_subnets.ids
  id = each.value
}



