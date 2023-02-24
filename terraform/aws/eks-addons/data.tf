
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_kms_key" "cluster_kms_key" {
  key_id = "alias/${var.cluster_kms_key_alias}"
}

data "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

locals {
  cluster_name                 = var.cluster_name
  # k8s_system_namespace         = "kube-system"
  
  ### karpenter
  karpenter_service_account_name      = "${var.cluster_name}-karpenter"
  karpenter_namespace      = "karpenter"

  ### argocd 
  argocd_namespace = "argocd"

  ### alb ingress
  alb_ingress_service_account_name = "${var.cluster_name}-alb-ingress"
  alb_ingress_namespace = "alb-ingress-controller"

  ### ebs csi
  ebs_csi_service_account_name = "${var.cluster_name}-ebs-csi"
  ebs_csi_namespace = "ebs-csi-controller"

  # ### efs csi
  # efs_csi_service_account_name = "${var.cluster_name}-efs-csi"
  # efs_csi_anmespace = "efs-csi-controller"

  # datadog vars
  datadog_namespace            = "datadog"
  datadog_service_account_name = "${var.cluster_name}-datadog"

  # prometheus vars
  prometheus_namespace         = "prometheus"


  # # splunk vars
  # splunk_namespace             = "splunk"
  # splunk_service_account_name  = "${var.cluster_name}-splunk"
  # # velero vars
  # velero_namespace             = "velero"
  # velero_service_account_name  = "${var.cluster_name}-velero"
  # velero_backup_bucket_key     = "velero-backups"
  tags = {
    env  = var.env
    app  = var.app
  }
}

data "aws_eks_cluster" "eks_cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = local.cluster_name
}

# data "aws_iam_user" "velero" {
#   user_name = "velero"
# }

# # Cluster karpenter policy document data
# data "aws_iam_policy_document" "karpenter" {
#   statement {
#     sid    = "karpenterAll"
#     effect = "Allow"

#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeTags",
#       "ec2:DescribeLaunchTemplateVersions",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     sid    = "clusterAutoscalerOwn"
#     effect = "Allow"

#     actions = [
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "autoscaling:UpdateAutoScalingGroup",
#     ]

#     resources = ["*"]

#     condition {
#       test     = "StringEquals"
#       variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/${data.aws_eks_cluster.eks_cluster.id}"
#       values   = ["owned"]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
#       values   = ["true"]
#     }
#   }
# }

# eks ebs-csi-driver policy document data
data "aws_iam_policy_document" "ebs_csi_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "CreateVolume",
        "CreateSnapshot",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateVolume",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"

      values = [
        "true",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateVolume",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"

      values = [
        "*",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateVolume",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/${data.aws_eks_cluster.eks_cluster.id}"

      values = [
        "owned",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteVolume",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"

      values = [
        "true",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteVolume",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"

      values = [
        "*",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteVolume",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/${data.aws_eks_cluster.eks_cluster.id}"

      values = [
        "owned",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"

      values = [
        "*",
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"

      values = [
        "true",
      ]
    }
  }
}


# # aws efs-csi-driver policy document data
# data "aws_iam_policy_document" "efs_csi_policy_document" {
#   statement {
#     actions = [
#       "elasticfilesystem:DescribeAccessPoints",
#       "elasticfilesystem:DescribeFileSystems",
#       "elasticfilesystem:DescribeAccessPoints",
#       "elasticfilesystem:DescribeFileSystems",
#       "elasticfilesystem:DescribeMountTargets"
#     ]

#     resources = [
#       "*",
#     ]
#   }

#   statement {
#     actions = [
#       "elasticfilesystem:CreateAccessPoint",
#     ]

#     resources = [
#       "*",
#     ]
#     condition {
#       test     = "StringLike"
#       variable = "aws:RequestTag/efs.csi.aws.com/cluster"

#       values = [
#         "true",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "elasticfilesystem:DeleteAccessPoint",
#       "ec2:DescribeSubnets",
#       "ec2:CreateNetworkInterface",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DeleteNetworkInterface",
#       "ec2:ModifyNetworkInterfaceAttribute",
#       "ec2:DescribeNetworkInterfaceAttribute",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeVpcAttribute"
#     ]

#     resources = [
#       "*",
#     ]
#     condition {
#       test     = "StringLike"
#       variable = "aws:ResourceTag/efs.csi.aws.com/cluster"

#       values = [
#         "true",
#       ]
#     }
#   }
# }


# # iam policy to give velero user access to cluster backup bucket
# data "aws_iam_policy_document" "velero_bucket_policy_document" {
#   statement {
#     sid    = "s3Allow"
#     effect = "Allow"

#     actions = [
#       "s3:ListBucket",
#       "s3:GetObject",
#       "s3:DeleteObject",
#       "s3:PutObject",
#       "s3:AbortMultipartUpload",
#       "s3:ListMultipartUploadParts"
#     ]

#     resources = [
#       "arn:aws:s3:::${module.velero_bucket.s3_bucket_id}",
#     ]
#   }
# }

