provider "aws" {
  region  = var.region
  // default_tags {
  //   tags = var.tags
  // }
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


provider "random" {

}

provider "local" {

}

provider "null" {

}

provider "template" {

}
