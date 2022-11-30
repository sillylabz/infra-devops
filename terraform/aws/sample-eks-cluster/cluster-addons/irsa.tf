
module "ebs_csi_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "5.8.0"
  role_name                          = "${local.cluster_name}-ebs-csi-role"
  attach_ebs_csi_policy = true
  ebs_csi_kms_cmk_ids = [data.aws_kms_key.cluster_kms_key.arn]
  oidc_providers = {
    main = {
      provider_arn               = data.aws_iam_openid_connect_provider.eks.arn
      namespace_service_accounts = ["${local.ebs_csi_namespace}:${local.ebs_csi_service_account_name}"]
    }
  }
}

module "loadbalancer_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "5.8.0"
  role_name                          = "${local.cluster_name}-loadbalancer-role"
  attach_load_balancer_controller_policy = true
  attach_load_balancer_controller_targetgroup_binding_only_policy = true
  oidc_providers = {
    main = {
      provider_arn               = data.aws_iam_openid_connect_provider.eks.arn
      namespace_service_accounts = ["${local.alb_ingress_namespace}:${local.alb_ingress_service_account_name}"]
    }
  }
}

module "karpenter_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "5.8.0"
  role_name                          = "${local.cluster_name}-karpenter-role"
  attach_karpenter_controller_policy = true
  karpenter_controller_cluster_id         = local.cluster_name
  oidc_providers = {
    main = {
      provider_arn               = data.aws_iam_openid_connect_provider.eks.arn
      namespace_service_accounts = ["${local.karpenter_namespace}:${local.karpenter_service_account_name}"]
    }
  }
}

module "alb_ingress_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "5.8.0"
  role_name                          = "${local.cluster_name}-loadbalancer-role"
  attach_load_balancer_controller_policy = true
  attach_load_balancer_controller_targetgroup_binding_only_policy = true
  oidc_providers = {
    main = {
      provider_arn               = data.aws_iam_openid_connect_provider.eks.arn
      namespace_service_accounts = ["${local.alb_ingress_namespace}:${local.alb_ingress_service_account_name}"]
    }
  }
}


