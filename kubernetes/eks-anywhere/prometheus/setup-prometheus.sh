#!/bin/sh

# adding helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Installing Prometheus
kubectl apply -f prometheus-pvc.yaml && \
helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    -f helm-values-dev.yaml \
    --create-namespace



