
fullnameOverride: "karpenter"
additionalLabels:
  app: karpenter


serviceAccount:
  create: true
  name: "${karpenter_service_account_name}"
  annotations:
    eks.amazonaws.com/role-arn: "${karpenter_aws_role_arn}"
replicas: 2
strategy:
  rollingUpdate:
    maxUnavailable: 1


controller:
  image: "public.ecr.aws/karpenter/controller:v0.19.2@sha256:dd3860b0c0e2fb73bb8392cb8468199bfc202b373ae6accdae83122174acb443"
  resources:
    requests:
      cpu: 0.25
      memory: 1Gi
    limits:
      cpu: 1
      memory: 2Gi



settings:
  batchMaxDuration: 10s
  batchIdleDuration: 1s
  aws:
    clusterName: "${cluster_name}"
    clusterEndpoint: "${cluster_endpoint}"
    defaultInstanceProfile: "${default_instance_profile}"
    vmMemoryOverheadPercent: 0.075
    interruptionQueueName: "${cluster_name}"
    tags:
      app: "${app}"
      env: "${env}"
      tier: "${tier}"

