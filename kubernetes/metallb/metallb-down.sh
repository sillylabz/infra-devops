#!/bin/sh

kubectl delete -f default-pool.yaml && \
helm -n metallb uninstall metallb \
    && kubectl delete ns metallb
