#!/bin/bash

helm -n nginx-ingress-controller \
    uninstall nginx-ingress-controller && \
    kubectl delete ns nginx-ingress-controller

