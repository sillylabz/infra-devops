cluster_name ?= k8s-kind-cluster-local

create-cluster:
	kind create cluster --config k8s-local-cluster.yaml

delete-cluster:
	kind delete cluster --name ${cluster_name}


