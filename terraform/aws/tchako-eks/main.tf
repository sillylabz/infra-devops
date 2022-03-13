# local vars
locals {
  prefix = "${var.project_name}-${var.environment}"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner
  }
}

# vpc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = "${local.prefix}-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = [var.subnet_cidrs["private1"], var.subnet_cidrs["private2"], var.subnet_cidrs["private3"]]
  private_subnet_tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-private"
    }
  )
  public_subnets = [var.subnet_cidrs["public1"], var.subnet_cidrs["public2"], var.subnet_cidrs["public3"]]
  public_subnet_tags = merge(
    local.tags,
    {
      Name = "${local.prefix}-public"
    }
  )

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  manage_default_security_group = false

  tags = local.tags
}

# security groups 
resource "aws_security_group" "eks_sg" {
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

# aws key pair


# eks cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.9.0"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_name                    = "${local.prefix}-eks-cluster"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true



  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts        = "OVERWRITE"
    }
  }

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    vpc_security_group_ids = [aws_security_group.eks_sg.id]
  }

  eks_managed_node_groups = {
    general_node = {
      min_size     = 2
      max_size     = 5
      desired_size = 2

      instance_types = ["t3.medium"]
      tags           = local.tags
    }
  }
}

