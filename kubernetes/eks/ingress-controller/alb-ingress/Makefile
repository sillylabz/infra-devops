account_id = 202334955716
policy_arn = arn:aws:iam::$(account_id):policy/AWSLoadBalancerControllerIAMPolicy
cluster_name = cloudops-cluster-dev

create-policy:
	aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://alb-policy.json


delete-policy:
	aws iam delete-policy \
    --policy-arn $(policy_arn)


setup-ingress-sa:
	sh ingress-setup.sh $(cluster_name)


remove-ingress-sa:
	eksctl delete iamserviceaccount --config-file=../../eksctl-iamserviceaccount-values.yaml --include kube-system/aws-load-balancer-controller --approve


install-ingress:
	helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller -f helm-values-alb-ingress.yaml -n kube-system


remove-ingress:
	helm uninstall -n kube-system aws-load-balancer-controller




