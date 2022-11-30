
fullnameOverride: "datadog"

datadog:
  apiKey: "${datadog_api_key}"
  clusterName: "${cluster_name}"
  site: datadoghq.com
  dd_url: https://app.datadoghq.com
  logLevel: INFO

  clusterChecks:
    enabled: true

  podLabelsAsTags:
    app: "${app}"
    tier: "${tier}"
    env: "${env}"

  # datadog.tags -- List of static tags to attach to every metric, event and service check collected by this Agent.
  ## Learn more about tagging: https://docs.datadoghq.com/tagging/
  tags:
    - "app:${app}"
    - "tier:${tier}"
    - "env:${env}"

