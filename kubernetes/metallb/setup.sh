#!/bin/sh

helm repo add metallb https://metallb.github.io/metallb && \
helm repo update && \
helm upgrade -i metallb metallb/metallb -f helm-values.yaml -n metallb --create-namespace


