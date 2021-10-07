#!/bin/sh

echo "======= Creating aws IAM roles for external dns ======="
terraform plan
terraform apply -auto-approve

ENV=dev
RELEASE_NAME="external-dns-$ENV"
DOMAIN_FILTER="*.sillycloudz.com"
HOSTED_ZONE_ID="ZU67IT00TIA9X"
ROLE_ARN="arn:aws:iam::107813131109:role/eks-external-dns-dev"
NAMESPACE_NAME="external-dns"


echo "======= Adding stable Helm Repo ======="
helm repo add stable https://charts.helm.sh/stable

echo "======= Updating Helm Repo ======="
helm repo update

echo "======= Installing external-dns to kubernetes cluster ======="
helm upgrade --install $RELEASE_NAME stable/external-dns \
--namespace=$NAMESPACE_NAME \
--create-namespace \
--set provider=aws \
--set domainFilters[0]=$DOMAIN_FILTER \
--set policy=sync \
--set registry=txt \
--set txtOwnerId=$HOSTED_ZONE_ID \
--set interval=3m \
--set rbac.create=true \
--set rbac.serviceAccountName=external-dns \


kubectl annotate serviceaccount -n $NAMESPACE_NAME $RELEASE_NAME \
eks.amazonaws.com/role-arn=$ROLE_ARN


