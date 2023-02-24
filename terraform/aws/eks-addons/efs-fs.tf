# resource "random_id" "suffix" {
#   byte_length = 2
# }



# # Create EFS FS to be used by EKS cluster
# module "cluster_efs" {
#   # count = var.create_efs_addon ? 1 : 0
#   source = "rhythmictech/efs-filesystem/aws"

#   name                    = "${local.cluster_name}-efs-${random_id.suffix.hex}"
#   allowed_security_groups = [data.aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]
#   subnets                 = data.aws_eks_cluster.eks_cluster.vpc_config[0].subnet_ids
#   enable_backups          = false
#   vpc_id                  = data.aws_eks_cluster.eks_cluster.vpc_config[0].vpc_id
#   efs_kms_key_id          = data.aws_kms_key.cluster_kms_key.arn
#   allowed_cidrs = []
#   additional_tags = merge(
#     local.tags,
#     {
#       Name = "${local.cluster_name}-efs-${random_id.suffix.hex}"
#     }
#   )
# }
