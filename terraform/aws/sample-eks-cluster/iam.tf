# Get the caller identity so that we can get the AWS Account ID
data "aws_caller_identity" "current" {}

# Get the EKS cluster we want to target
data "aws_eks_cluster" "eks" {
  name = local.cluster_name
  depends_on = [
    module.eks
  ]
}

# Create the IAM role that will be assumed by the service account
resource "aws_iam_role" "iam_role_service_account" {
  name               = "${local.cluster_name}-role"
  assume_role_policy = data.aws_iam_policy_document.iam_role_service_account.json
}

# Create IAM policy allowing the k8s service account to assume the IAM role
data "aws_iam_policy_document" "iam_role_service_account" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_oidc_issuer}"
      ]
    }

    # Limit the scope so that only our desired service account can assume this role
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer}:sub"
      values = [
        "system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"
      ]
    }
  }
}

# Attach Secrets Access policy
resource "aws_iam_role_policy_attachment" "secrets_policy_exec" {
  role       = aws_iam_role.iam_role_service_account.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}