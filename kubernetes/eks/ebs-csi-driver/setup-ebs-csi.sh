#!/bin/sh 
PROJECT_NAME=$2
PROJECT_ENV=$3
EBS_CSI_POLICY_NAME="$PROJECT_NAME-$PROJECT_ENV-eks-ebs-policy"
EBS_CONTROLLER_NAME="ebs-csi-controller"
AWS_REGION="us-east-1"
CLUSTER_NAME=$1


# export the policy ARN as a variable
EBS_CSI_POLICY_ARN=$(aws --region ${AWS_REGION} iam list-policies --query 'Policies[?PolicyName==`sample-dev-eks-ebs-policy`].Arn' --output text)

# Create an IAM OIDC provider for your cluster
eksctl utils associate-iam-oidc-provider \
  --region=$AWS_REGION \
  --cluster=$CLUSTER_NAME \
  --approve

# Create a service account
eksctl create iamserviceaccount \
  --namespace kube-system \
  --attach-policy-arn $EBS_CSI_POLICY_ARN \
  --include kube-system/$EBS_CONTROLLER_NAME \
  --override-existing-serviceaccounts \
  --approve

# add the aws-ebs-csi-driver as a helm repo
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update

# helm install ebs csi driver to eks cluster
helm upgrade -i ebs-csi-controller aws-ebs-csi-driver/aws-ebs-csi-driver -f helm-values-ebs-csi.yaml -n kube-system
