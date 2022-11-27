# Setup ALB ingress controller on EKS cluster

## Installation and configuration
- check oidc

`cluster_name=zero-dev-cluster`
`aws eks describe-cluster --name $cluster_name  --query "cluster.identity.oidc.issuer" --output text`

- create and associate oidc provider to eks cluster
`eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=$cluster_name  --approve`

- check oidc provider
`aws iam list-open-id-connect-providers | grep 9B6HGDFJAAGF4A0228C3F5`

- create iam service account for ALB controller
```sh
eksctl create iamserviceaccount \
  --cluster=$cluster_name  \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::202334955716:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --tags "Environment=DEV,Cost Center=1000,Owner=Sam Thompson" \
  --approve 
```

- Install cert-manager
`kubectl apply --validate=false -f cert-manager.yaml`

- Install ALB controller
`kubectl apply --validate=false -f alb-ingress-controller.yaml`


## Clean up

- delete kube resources
`kubectl delete  -f alb-ingress-controller.yaml,cert-manager.yaml`

- delete iam service account for ALB controller
```sh
eksctl delete iamserviceaccount \
  --cluster=zero-dev-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller 
```

- delete openid provider
```sh
aws iam delete-open-id-connect-provider \
  --open-id-connect-provider-arn arn:aws:iam::202334955716:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/9B6FCBF0BE3C51622F789F4A0228C3F5
```

