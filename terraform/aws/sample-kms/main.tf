// terraform {
//   required_version = "~> 1.0"

//   backend "s3" {
//     encrypt = true
//     bucket = "s3_bucket_name"
//     dynamodb_table = "dynamo_db_table_name"
//     region = "us-east-1"
//     key = "cluster_name/terraform.tfstate"
//   }
// }



// CMK for sample cryptographic operations
module "sample_kms_key" {
  source = "clouddrove/kms/aws"

  name                    = "${var.project_name}-cmk-dev"
  enabled                 = true
  description             = "KMS key for cryptographic operations"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/${var.project_name}-cmk-${var.environment}"
  policy                  = data.aws_iam_policy_document.sample_kms_policy.json
  tags                    = var.tags
}


// CMK IAM policy for secrets manager
data "aws_iam_policy_document" "sample_kms_policy" {
  version = "2012-10-17"
  statement {
    sid    = "AWS admin KMS IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.aws_admin_role_arn
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow principals in the account to decrypt log files"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.user_role_arn
    }
    actions = [
      "kms:CreateGrant",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Get*",
      "kms:TagResource",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow alias creation during setup"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:CreateAlias"]
    resources = ["*"]
  }
}

