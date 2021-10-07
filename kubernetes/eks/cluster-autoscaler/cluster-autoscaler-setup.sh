#!/bin/sh

cluster_name="sample-eks-cluster-dev"
ca_policy_arn=$(aws iam list-policies --query 'Policies[? PolicyName==`cluster-autoscaler2021090703033983330000000a`].Arn' --output text)


# Attach oidc provider to eks cluster
eksctl utils associate-iam-oidc-provider \
    --cluster $cluster_name \
    --approve


# Create server account and attach iam policy document
eksctl create iamserviceaccount \
    --name cluster-autoscaler \
    --namespace kube-system \
    --cluster $cluster_name \
    --attach-policy-arn $ca_policy_arn \
    --approve \
    --override-existing-serviceaccounts


helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update 


helm upgrade -i cluster-autoscaler autoscaler/cluster-autoscaler \
  --namespace kube-system \
  -f helm-values-dev.yaml
