terraform {
  required_version = ">= 0.12"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# ebs csi driver iam policy
resource "aws_iam_policy" "aws_ebs_csi_policy" {
  name   = "${var.project_name}-${var.env}-eks-ebs-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.aws_ebs_csi_policy_document.json
}

# efs csi driver iam policy
resource "aws_iam_policy" "aws_efs_csi_policy" {
  name   = "${var.project_name}-${var.env}-eks-efs-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.aws_efs_csi_policy_document.json
}

module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  cluster_name       = local.cluster_name
  cluster_version    = "1.19"
  subnets            = data.aws_subnet_ids.private_subnets.ids
  write_kubeconfig   = false
  manage_aws_auth    = false
  
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id = data.aws_vpc.selected.id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    root_encrypted = true
    root_kms_key_id = data.aws_kms_key.sample_kms_key.arn
    additional_tags = var.tags
  }

  node_groups = {
    general_purpose = {
      name_prefix = "general-purpose"
      desired_capacity = var.gp_node_group_desired_capacity
      max_capacity     = var.gp_node_group_max_capacity
      min_capacity     = var.gp_node_group_min_capacity
      disk_size = var.gp_node_group_disk_size
      subnets = data.aws_subnet_ids.private_subnets.ids

      instance_types = [var.gp_node_group_instance_type]
      capacity_type  = var.gc_node_group_capacity_type
      k8s_labels = {
        Environment = var.env
        "Name" = "${local.cluster_name}-gp-worker-nodes"
      }
    }
  }


  # Create security group rules to allow communication between pods on workers and pods in managed node groups.
  # Set this to true if you have AWS-Managed node groups and Self-Managed worker groups.
  # See https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1089
  worker_create_cluster_primary_security_group_rules = true
  
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




