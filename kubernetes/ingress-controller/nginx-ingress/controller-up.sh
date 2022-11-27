#!/bin/bash

helm upgrade -i nginx-ingress-controller nginx-ingress \
    --repo https://helm.nginx.com/stable \
    -f helm-values.yaml \
    --namespace nginx-ingress-controller \
    --create-namespace 



