#!/bin/sh
cluster_name=$1
export ALB_CONTROLLER_NAME="aws-load-balancer-controller"

aws eks describe-cluster --name $cluster_name  --query "cluster.identity.oidc.issuer" --output text

# create and associate oidc provider to eks cluster
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=$cluster_name  --approve

# create iamserviceaccount for alb ingress controller
eksctl create iamserviceaccount \
  --config-file=../../eksctl-iamserviceaccount-values.yaml \
  --include kube-system/$ALB_CONTROLLER_NAME \
  --override-existing-serviceaccounts \
  --approve


# add helm repo
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# helm install alb ingress controller
helm upgrade -i aws-load-balancer-controller aws-load-balancer-controller \
  --repo https://aws.github.io/eks-charts \
  -n alb-ingress-controller \
  --create-namespace \
  -f helm-values-alb-ingress.yaml


