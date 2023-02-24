replicaCount: 3

image:
  repository: 602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon/aws-load-balancer-controller
  tag: "${image_tag}"
  pullPolicy: IfNotPresent

fullnameOverride: "aws-load-balancer-controller"

clusterName: "${cluster_name}"

serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: "${alb_ingress_controller_role_arn}"
  name: "${alb_ingress_service_account_name}"
  automountServiceAccountToken: true

rbac:
  create: true

resources: 
  limits:
    cpu: 500m
    memory: 1Gi
  requests:
    cpu: 100m
    memory: 128Mi

ingressClass: alb

region: "${aws_region}"

defaultTags: 
  env: "dev"
  app: "sre"
  tier: "tools"

podDisruptionBudget:
  maxUnavailable: 1

