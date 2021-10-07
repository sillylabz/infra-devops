terraform {
  required_version = ">= 0.12.6"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.47"

  name                 = "test-eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}


module "eks" {
  source          = "git@github.com:hernanku/infra-devops.git//terraform/modules/aws-eks"
  cluster_name    = local.cluster_name
  cluster_version = "1.19"
  cluster_subnets         = module.vpc.public_subnets
  write_kubeconfig = false
  manage_aws_auth = false
  fargate_subnets = module.vpc.private_subnets
  cluster_create_security_group = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  fargate_profile_name = "${local.cluster_name}-fp"
  // node_group_name = "${local.cluster_name}-nodegroup"

  tags = var.tags

  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
  }

  // fargate_profiles = {
  //   zero_dev = {
  //     namespace = "default"
  //     fargate_subnets = module.vpc.private_subnets
      
  //     tags = var.tags
  //   }
  // }


  node_groups = {
    mng-nodes = {
      name = "eks-node-groups"
      desired_capacity = 4
      max_capacity     = 10
      min_capacity     = 2

      instance_types = ["t2.large"]
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        Environment = "DEV"
        "Name" = "eks-worker-nodes"
      }
    }
  }

  # Create security group rules to allow communication between pods on workers and pods in managed node groups.
  # Set this to true if you have AWS-Managed node groups and Self-Managed worker groups.
  # See https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1089

  worker_create_cluster_primary_security_group_rules = true
  worker_groups_launch_template = [
    {
      name                 = "dev-workergroup-lt"
      instance_type        = "t2.large"
      asg_desired_capacity = 2
      public_ip            = false
    }
  ]

  workers_group_defaults = {
    tag = [{
      "Name" = "eks-worker-dev-nodes"
    }]
  }

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}



### vpc endpoints
data aws_iam_policy_document "allow_all" {
  statement {
    actions = ["*"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = ["*"]
  }
}






