#!/bin/sh

helm upgrade -i metallb metallb \
    --repo https://metallb.github.io/metallb \
    -f helm-values.yaml \
    -n metallb \
    --create-namespace

if [[ $? -eq 0 ]]; then
    sleep 60s && \
        kubectl apply -f default-pool.yaml
fi

