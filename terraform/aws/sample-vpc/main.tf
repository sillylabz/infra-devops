terraform {
  required_version = ">= 1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.30.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.14.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}


locals {
  name = "${var.project_name}-vpc-${var.environment}"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = local.name
  cidr = var.vpc_cidr

  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b",
    "${var.aws_region}c"
  ]
  private_subnets = [
    var.subnet_cidrs["private1"],
    var.subnet_cidrs["private2"],
    var.subnet_cidrs["private3"]
  ]
  private_subnet_tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-private-${var.environment}"
    }
  )
  public_subnets = [
    var.subnet_cidrs["public1"],
    var.subnet_cidrs["public2"],
    var.subnet_cidrs["public3"]
  ]
  map_public_ip_on_launch = true
  public_subnet_tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-public-${var.environment}"
    }
  )
  database_subnets = [
    var.subnet_cidrs["database1"],
    var.subnet_cidrs["database2"],
    var.subnet_cidrs["database3"]
  ]
  database_subnet_tags = merge(
    local.tags,
    {
      Name = "${var.project_name}-database-${var.environment}"
    }
  )
  create_database_subnet_group = true

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group = false

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  tags = local.tags

}


# #Security groups
# vpc endpoint Security Group
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc_endpoint_sg"
  description = "Allow VPC traffic to communicate with AWS Services"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

