
# karpenter auto scaler helm deployment
resource "helm_release" "karpenter" {
  name            = "karpenter"
  chart           = "oci://public.ecr.aws/karpenter/karpenter"
  namespace       = local.karpenter_namespace
  create_namespace = true
  cleanup_on_fail = true
  atomic          = true

  values = [
    templatefile(
      "${path.module}/templates/karpenter-helm-values.tpl",
      {
        karpenter_service_account_name = local.karpenter_service_account_name,
        karpenter_aws_role_arn = module.karpenter_irsa_role.iam_role_arn,
        cluster_name = local.cluster_name,
        cluster_endpoint = data.aws_eks_cluster.eks_cluster.endpoint,
        default_instance_profile = "KarpenterNodeInstanceProfile-${local.cluster_name}",
        env                  = var.env,
        app                        = var.app
      }
    )
  ]
}


# argocd helm deployment
resource "helm_release" "argocd" {
  name            = "argocd"
  chart           = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace       = local.argocd_namespace
  create_namespace = true
  cleanup_on_fail = true
  atomic          = true

  values = []
}


# ebs csi helm deployment
resource "helm_release" "ebs_csi_controller" {
  name            = "ebs-csi-controller"
  chart           = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  namespace       = local.ebs_csi_namespace
  create_namespace = true
  cleanup_on_fail = true
  atomic          = true

  values = [
    templatefile(
      "${path.module}/templates/ebs-csi-helm-values.tpl",
      {
        aws_region                   = var.aws_region,
        ebs_controller_image_version = var.ebs_controller_image_version
        env                  = var.env,
        app                        = var.app,
        cluster_name                 = local.cluster_name,
        ebs_default_storage_class    = true,
        ebs_csi_service_account_name = local.ebs_csi_service_account_name,
        ebs_csi_aws_role_arn         = module.ebs_csi_irsa_role.iam_role_arn
      }
    )
  ]
}


# alb ingress controller helm deployment
resource "helm_release" "alb_ingress_controller" {
  name             = "alb-ingress-controller"
  chart            = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  namespace        = local.alb_ingress_namespace
  create_namespace = true
  cleanup_on_fail  = true
  values = [
    templatefile(
      "${path.module}/templates/alb-ingress-values.tpl",
      {
        image_tag                        = "v2.4.5",
        alb_ingress_controller_role_arn  = module.loadbalancer_ingress_irsa_role.iam_role_arn,
        alb_ingress_service_account_name = local.alb_ingress_service_account_name,
        cluster_name                     = local.cluster_name,
        aws_region                       = var.aws_region,
        app                              = var.app,
        tier                             = var.tier,
        env                              = var.env
      }
    )
  ]
}


# datadog helm deployment
resource "helm_release" "datadog" {
  name            = "datadog"
  chart           = "datadog"
  repository = "https://helm.datadoghq.com"
  namespace       = local.datadog_namespace
  create_namespace = true
  cleanup_on_fail = true
  values = [
    templatefile(
      "${path.module}/templates/datadog-helm-values.tpl",
      {
        datadog_service_account_name = local.datadog_service_account_name,
        cluster_name                 = local.cluster_name,
        env                  = var.env,
        app                        = var.app,
        datadog_api_key = var.datadog_api_key
      }
    )
  ]
}


# prometheus helm deployment
resource "helm_release" "prometheus" {
  name            = "prometheus"
  chart           = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace       = local.prometheus_namespace
  create_namespace = true
  cleanup_on_fail = true
  // atomic          = true
  values = [
    templatefile(
      "${path.module}/templates/prometheus-helm.tpl", {
        alertmanager_enable_pv = false,
        alertmanager_pvc_size = "10Gi",
        alertmanager_pvc_sc = "ebs-csi-sc",
        server_enable_pv = false,
        server_pvc_size = "10Gi",
        server_pvc_sc = "ebs-csi-sc",
        pushgateway_enable_pv = false,
        pushgateway_pvc_size = "10Gi",
        pushgateway_pvc_sc = "ebs-csi-sc"
      }
    )
  ]

  depends_on = [
    helm_release.ebs_csi_controller
  ]
}


# # velero backups
# resource "helm_release" "velero_backup" {
#   name             = "velero"
#   namespace        = local.velero_namespace
#   create_namespace = true
#   chart = "velero"
#   repository       = "https://vmware-tanzu.github.io/helm-charts"

#   values = [
#     templatefile("${path.module}/templates/velero-helm-values.tpl",
#       {
#         environment                  = var.environment,
#         owner                        = var.owner,
#         cost_center                  = var.cost_center,
#         velero_backup_bucket        = module.velero_bucket.s3_bucket_id,
#         velero_service_account_name = local.velero_service_account_name,
#         velero_user_aws_access_key     = var.velero_user_aws_access_key,
#         velero_user_aws_secret_access_key = var.velero_user_aws_secret_access_key,
#         velero_backup_loaction_name = var.velero_backup_location_name,
#         velero_backup_bucket_key    = local.velero_backup_bucket_key,
#         velero_backup_snapshot_name = var.velero_backup_snapshot_name
#       }
#     ),
#   ]

# }

