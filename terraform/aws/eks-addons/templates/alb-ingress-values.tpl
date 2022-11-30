
replicaCount: 2

image:
  repository: 602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon/aws-load-balancer-controller
  tag: "${image_tag}"
  pullPolicy: IfNotPresent

fullnameOverride: "alb-ingress-controller"

serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: "${alb_ingress_controller_role_arn}"
  name: "${alb_ingress_controller_role_arn}"
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

updateStrategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 1
enableCertManager: false
clusterName: "${cluster_name}"
cluster:
    dnsDomain: cluster.local
ingressClass: alb
ingressClassParams:
  create: true
region: "${aws_region}"

livenessProbe:
  failureThreshold: 2
  httpGet:
    path: /healthz
    port: 61779
    scheme: HTTP
  initialDelaySeconds: 30
  timeoutSeconds: 10

defaultTags: {}
  app: "${app}"
  tier: "${tier}"
  env: "${env}"

