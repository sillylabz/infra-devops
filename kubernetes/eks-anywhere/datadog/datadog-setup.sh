#!/bin/sh
export cluster_name=$1
# export datadog_api_key=$2

helm repo add datadog https://helm.datadoghq.com
helm repo update

# helm upgrade -i datadog datadog/datadog \
#   --namespace datadog \
#   -f dev-values.yaml \
#   --create-namespace 

helm upgrade -i datadog datadog/datadog \
  --namespace datadog \
  --set targetSystem="linux" \
  --set datadog.apiKey="5ddaebdbd79d77a3719be6ae308ccc58" \
  --set datadog.clusterName=$cluster_name \
  --set datadog.containerExcludeLogs="image:splunk/fluentd-hec image:sig-storage/livenessprobe image:kubernetes-csi/livenessprobe" \
  --set datadog.logLevel="info" \
  --set datadog.kubeStateMetricsEnabled="true" \
  --set datadog.kubeStateMetricsNetworkPolicy.create="true" \
  --set datadog.kubeStateMetricsCore.create="true" \
  --set datadog.clusterChecks.enabled="true" \
  --set datadog.kubelet.tlsVerify="true" \
  --set datadog.dogstatsd.tagCardinality="low" \
  --set datadog.dogstatsd.useSocketVolume="false" \
  --set datadog.dogstatsd.nonLocalTraffic="true" \
  --set datadog.collectEvents="true" \
  --set datadog.leaderElection="true" \
  --set datadog.logs.enabled="true" \
  --set datadog.logs.containerCollectAll="true" \
  --set datadog.logs.containerCollectUsingFiles="false" \
  --set datadog.serviceTopology.enabled="false" \
  --set datadog.serviceTopology.serviceName="datadog-agent" \
  --set datadog.processAgent.enabled="true" \
  --set datadog.processAgent.processCollection="true" \
  --set datadog.systemProbe.enableConntrack="true" \
  --set datadog.systemProbe.bpfDebug="true" \
  --set datadog.systemProbe.collectDNSStats="true" \
  --set datadog.orchestratorExplorer.enabled="true" \
  --set datadog.orchestratorExplorer.container_scrubbing.enabled="true" \
  --set datadog.networkMonitoring.enabled="true" \
  --set datadog.networkPolicy.create="true" \
  --set datadog.prometheusScrape.enabled="true" \
  --set datadog.prometheusScrape.serviceEndpoints="true" \
  --set clusterAgent.enabled="true" \
  --set clusterAgent.rbac.create="true" \
  --set clusterAgent.metricsProvider.enabled="true" \
  --set clusterAgent.metricsProvider.useDatadogMetrics="true" \
  --set clusterAgent.metricsProvider.createReaderRbac="true" \
  --set clusterAgent.resources.limits.cpu="600m" \
  --set clusterAgent.resources.limits.memory="1000Mi" \
  --set clusterAgent.rbac.serviceAccountName="$cluster_name-datadog-clusterAgent" \
  --set agents.enabled="true" \
  --set agents.tag.tag="7.30.0" \
  --set agents.rbac.create="true" \
  --set agents.rbac.serviceAccountName="$cluster_name-datadog-agents" \
  --set agents.podSecurity.apparmor.enabled="true" \
  --set agents.containers.agent.resources.limits.cpu="600m" \
  --set agents.containers.agent.resources.limits.memory="1000Mi" \
  --set agents.containers.processAgent.resources.limits.cpu="300m" \
  --set agents.containers.processAgent.resources.limits.memory="600Mi" \
  --set agents.containers.traceAgent.resources.limits.cpu="300m" \
  --set agents.containers.traceAgent.resources.limits.memory="600Mi" \
  --set agents.containers.systemProbe.resources.limits.cpu="300m" \
  --set agents.containers.systemProbe.resources.limits.memory="600Mi" \
  --set agents.containers.securityAgent.resources.limits.cpu="300m" \
  --set agents.containers.securityAgent.resources.limits.memory="600Mi" \
  --set agents.containers.initContainers.resources.limits.cpu="300m" \
  --set agents.containers.initContainers.resources.limits.memory="600Mi" \
  --set clusterChecksRunner.enabled="true" \
  --set clusterChecksRunner.image.tag="7.30.0" \
  --set clusterChecksRunner.rbac.create="true" \
  --set clusterChecksRunner.rbac.serviceAccountName="$cluster_name-datadog-clusterChecksRunner" \
  --set clusterChecksRunner.resources.limits.cpu="600m" \
  --set clusterChecksRunner.resources.limits.memory="1500Mi" \
  --set datadog-crds.crds.datadogMetrics="true" \
  --set kube-state-metrics.rbac.create="true" \
  --set kube-state-metrics.serviceAccount.create="true" \
  --set kube-state-metrics.rbac.serviceAccount.name="$cluster_name-datadog-metrics" \
  --set kube-state-metrics.resources.limits.cpu="600m" \
  --set kube-state-metrics.resources.limits.memory="1000Mi" \
  --set kube-state-metrics.image.tag="v1.9.8" \
  --create-namespace 




