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

locals {
  cluster_name                  = "${var.app}-${var.env}-cluster"
  k8s_service_account_name      = "${local.cluster_name}-irsa"
  k8s_service_account_namespace = local.cluster_name

  # Get the EKS OIDC Issuer without https:// prefix
  eks_oidc_issuer = trimprefix(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://")

  system_masters_users = [for user in var.system_masters_users : {
    userarn  = "arn:aws:iam::${var.aws_account_id}:user/${user}"
    username = user
    groups   = ["system:masters"]
    }
  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = data.aws_vpc.vpc.id
  subnet_ids      = tolist(data.aws_subnets.public.ids)
  aws_auth_users  = local.system_masters_users

  manage_aws_auth_configmap = true

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_security_group_additional_rules = {
    ingress_all_443_api = {
      description      = "API all ingress"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  create_kms_key = true
  cluster_encryption_config = [{
    resources = ["secrets"]
  }]
  kms_key_deletion_window_in_days = 7
  enable_kms_key_rotation         = true

  cluster_addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {}
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = var.eks_managed_node_groups

  tags = {
    env  = var.env
    app  = var.app
  }
}

