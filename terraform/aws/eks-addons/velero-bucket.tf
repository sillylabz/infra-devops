
# resource "aws_iam_policy" "velero_bucket_policy" {
#   name        = "${local.cluster_name}-velero-s3-policy"
#   description = "policy for velero cluster to access s3 backup bucket ${module.velero_bucket.s3_bucket_id}"
#   policy      = data.aws_iam_policy_document.velero_bucket_policy_document.json
# }

# resource "aws_iam_policy_attachment" "velero_bucket_policy_attachment" {
#   name       = "${local.cluster_name}-velero-policy-attachment-${lower(var.environment)}"
#   users      = [data.aws_iam_user.velero.user_name]
#   policy_arn = aws_iam_policy.velero_bucket_policy.arn
# }

# # eks cluster backup s3 bucket
# module "velero_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = "${local.cluster_name}-backups-${random_id.suffix.hex}"
#   acl    = "private"

#   # Allow deletion of non-empty bucket
#   force_destroy = true

#   attach_policy = false
#   //   policy        = aws_iam_policy.velero_bucket_policy.json

#   tags = local.tags
# }


