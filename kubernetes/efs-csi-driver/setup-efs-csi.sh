#!/bin/sh
export PROJECT_NAME=$2
export PROJECT_ENV=$3
export EFS_CSI_POLICY_NAME=""$PROJECT_NAME-$PROJECT_ENV-eks-efs-policy""
export EFS_CONTROLLER_NAME="efs-csi-controller"
export AWS_REGION="us-east-1"
export CLUSTER_NAME=$1

# export the policy ARN as a variable
# export EFS_CSI_POLICY_ARN=$(aws --region ${AWS_REGION} iam list-policies --query 'Policies[?PolicyName==`'$EFS_CSI_POLICY_NAME'`].Arn' --output text)

# Create an IAM OIDC provider for your cluster
eksctl utils associate-iam-oidc-provider \
  --region=$AWS_REGION \
  --cluster=$CLUSTER_NAME \
  --approve

# Create a service account
eksctl create iamserviceaccount \
  --config-file=../eksctl-iamserviceaccount-values.yaml \
  --include kube-system/$EFS_CONTROLLER_NAME \
  --override-existing-serviceaccounts \
  --tags
  --approve

# add the aws-ebs-csi-driver as a helm repo
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update

# helm install efs csi driver to eks cluster
helm upgrade -i efs-csi-controller -n kube-system aws-efs-csi-driver/aws-efs-csi-driver -f helm-values-efs-csi.yaml

