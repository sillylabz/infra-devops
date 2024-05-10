#!/bin/bash

helm upgrade -i ingress-nginx-controller ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    -f helm-values.yaml \
    --namespace ingress-nginx-controller \
    --create-namespace 



