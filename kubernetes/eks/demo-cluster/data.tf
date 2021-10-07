data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_region" "current" {}


data "aws_availability_zones" "available" {
}


locals {
  cluster_name = "${var.project_name}-cluster"
}