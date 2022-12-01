rbac:
  create: true


alertmanager:
  enabled: true
  persistentVolume:
    enabled: "${alertmanager_enable_pv}"
    accessModes:
      - ReadWriteOnce
    annotations: {}

    mountPath: /data
    size: "${alertmanager_pvc_size}"
    storageClass: "${alertmanager_pvc_sc}"


server:
  enabled: true
  persistentVolume:
    enabled: "${server_enable_pv}"
    accessModes:
      - ReadWriteOnce
    annotations: {}

    mountPath: /data
    size: "${server_pvc_size}"
    storageClass: "${server_pvc_sc}"


prometheus-pushgateway:
  enabled: true
  persistentVolume:
    enabled: "${pushgateway_enable_pv}"
    accessModes:
      - ReadWriteOnce
    annotations: {}

    mountPath: /data
    size: "${pushgateway_pvc_size}"
    storageClass: "${pushgateway_pvc_sc}"


kubeStateMetrics:
  enabled: true

kube-state-metrics:
  podAnnotations: 
    ad.datadoghq.com/kube-state-metrics.check_names: |
      ["openmetrics"]
    ad.datadoghq.com/kube-state-metrics.init_configs: |
      [{}]
    ad.datadoghq.com/kube-state-metrics.instances: |
      [
        {
          "prometheus_url": "http://%%kube-state-metrics%%:%%8080%%/metrics "
        }
      ]

