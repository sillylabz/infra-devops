

image:
  repository: k8s.gcr.io/provider-aws/aws-ebs-csi-driver
  tag: "${ebs_controller_image_version}"
  pullPolicy: IfNotPresent

fullnameOverride: ebs-csi-controller

controller:
  defaultFsType: ext4
  extraCreateMetadata: true
  extraVolumeTags:
    Cluster: "${cluster_name}"
    App: "${app}"
    Tier: "${tier}"
    Env: "${env}"
  logLevel: 2
  priorityClassName: system-cluster-critical
  region: "${aws_region}"
  replicaCount: 2
  updateStrategy: 
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 0
      maxUnavailable: 1
  resources: 
    limits:
      cpu: 300m
      memory: 512Mi
    requests:
      cpu: 100m
      memory: 128Mi
  serviceAccount:
    create: true
    name: "${ebs_csi_service_account_name}"
    annotations: 
      eks.amazonaws.com/role-arn: "${ebs_csi_aws_role_arn}"

node:
  serviceAccount:
    create: true
    name: "${ebs_csi_service_account_name}-node"
    annotations:
      eks.amazonaws.com/role-arn: "${ebs_csi_aws_role_arn}"
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: "10%"

storageClasses: 
  - name: ebs-csi-sc
    annotations:
      storageclass.kubernetes.io/is-default-class: "${ebs_default_storage_class}"
    volumeBindingMode: WaitForFirstConsumer
    reclaimPolicy: Delete
    parameters:
      encrypted: "true"

