# Default values for aws-efs-csi-driver.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

nameOverride: ""
fullnameOverride: ""

replicaCount: 2

image:
  repository: amazon/aws-efs-csi-driver
  tag: "v1.3.2"
  pullPolicy: IfNotPresent

sidecars:
  livenessProbe:
    image:
      repository: public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe
      tag: v2.2.0-eks-1-18-2
      pullPolicy: IfNotPresent
    resources: {}
  nodeDriverRegistrar:
    image:
      repository: public.ecr.aws/eks-distro/kubernetes-csi/node-driver-registrar
      tag: v2.1.0-eks-1-18-2
      pullPolicy: IfNotPresent
    resources: {}
  csiProvisioner:
    image:
      repository: public.ecr.aws/eks-distro/kubernetes-csi/external-provisioner
      tag: v2.1.1-eks-1-18-2
      pullPolicy: IfNotPresent
    resources: {}

imagePullSecrets: []

## Controller deployment variables

controller:
  # Specifies whether a deployment should be created
  create: true
  # Number for the log level verbosity
  logLevel: 2
  # If set, add pv/pvc metadata to plugin create requests as parameters.
  extraCreateMetadata: true
  # Add additional tags to access points
  tags: 
    region: "${efs_fs_region_tag}"
    Cluster: "${cluster_name}"
    Owner: "${owner}"
    "Cost Center": "${cost_center}"
    Environment: "${environment}"
  # Enable if you want the controller to also delete the
  # path on efs when deleteing an access point
  deleteAccessPointRootDir: true
  podAnnotations: {}
  resources: 
    # We usually recommend not to specify default resources and to leave this as a conscious
    # choice for the user. This also increases chances charts run on environments with little
    # resources, such as Minikube. If you do want to specify resources, uncomment the following
    # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
    limits:
      cpu: 300m
      memory: 512Mi
    requests:
      cpu: 100m
      memory: 128Mi
  nodeSelector: {}
  tolerations: []
  affinity: {}
  # Specifies whether a service account should be created
  serviceAccount:
    create: true
    name: "${efs_csi_service_account_name}"
    annotations: 
    ## Enable if EKS IAM for SA is used
      eks.amazonaws.com/role-arn: "${efs_csi_aws_role_arn}"

## Node daemonset variables

node:
  # Number for the log level verbosity
  logLevel: 2
  hostAliases: {}
    # For cross VPC EFS, you need to poison or overwrite the DNS for the efs volume as per
    # https://docs.aws.amazon.com/efs/latest/ug/efs-different-vpc.html#wt6-efs-utils-step3
    # implementing the suggested solution found here:
    # https://github.com/kubernetes-sigs/aws-efs-csi-driver/issues/240#issuecomment-676849346
    # EFS Vol ID, IP, Region
    # "fs-01234567":
    #   ip: 10.10.2.2
    #   region: us-east-2
  dnsPolicy: ClusterFirst
  dnsConfig: {}
    # Example config which uses the AWS nameservers
    # dnsPolicy: "None"
    # dnsConfig:
    #   nameservers:
    #     - 169.254.169.253
  podAnnotations: {}
  resources: 
    limits:
      cpu: 300m
      memory: 512Mi
    requests:
      cpu: 100m
      memory: 128Mi
  nodeSelector: {}
  tolerations:
    - operator: Exists

storageClasses: 
  - name: efs-sc
    annotations:
      # Use that annotation if you want this to your default storageclass
      storageclass.kubernetes.io/is-default-class: "${efs_default_storage_class}"
    mountOptions:
    - tls
    parameters:
      provisioningMode: efs-ap
      fileSystemId: "${efs_csi_fs}"
      directoryPerms: "700"
      gidRangeStart: "1000"
      gidRangeEnd: "2000"
      basePath: "/dynamic_provisioning"
    reclaimPolicy: Delete
    volumeBindingMode: WaitForFirstConsumer

