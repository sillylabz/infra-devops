data "aws_region" "current" {}


data "aws_availability_zones" "available" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.selected.id

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.selected.id

filter {
    name = "tag:Name"
    values = ["sample-private01", "sample-private02"]
  }
}

data "aws_subnet" "private_subnet_list" {
  for_each = data.aws_subnet_ids.private_subnets.ids
  id = each.value
}


locals {
  cluster_name = "${var.project_name}-eks-cluster-${var.env}"
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler"
}


# eks ebs-csi-driver policy document data
data "aws_iam_policy_document" "aws_ebs_csi_policy_document" {
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
      test = "StringEquals"
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
      test = "StringLike"
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
      test = "StringLike"
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
      test = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"

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
      test = "StringLike"
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
      test = "StringLike"
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
      test = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/*"

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
      test = "StringLike"
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
      test = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"

      values = [
        "true",
      ]
    }
  }
}


# aws efs-csi-driver policy document data
data "aws_iam_policy_document" "aws_efs_csi_policy_document" {
  statement {
    actions = [
     "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "elasticfilesystem:CreateAccessPoint",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"

      values = [
        "true",
      ]
    }
  }

  statement {
    actions = [
      "elasticfilesystem:DeleteAccessPoint",
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"

      values = [
        "true",
      ]
    }
  }
}




