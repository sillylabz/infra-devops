#!/bin/sh
ENV=dev
RELEASE_NAME="external-dns-$ENV"
NAMESPACE_NAME="external-dns"


helm uninstall $RELEASE_NAME -n $NAMESPACE_NAME
k delete ns $NAMESPACE_NAME


terraform destroy -auto-approve
