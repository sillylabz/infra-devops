// output "eks_node_group_names" {
//   value = { for k, v in data.aws_eks_node_group.eks_cluster_node_group.id : k => v.id }
// }


output "oidc_provider_arn" {
  value = data.aws_iam_openid_connect_provider.eks.arn
}

