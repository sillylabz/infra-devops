#!/bin/bash

helm -n ingress-nginx-controller \
    uninstall ingress-nginx-controller && \
    kubectl delete ns ingress-nginx-controller

