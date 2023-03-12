deploy-cilium:
	helm upgrade -i cilium cilium \
		--repo https://helm.cilium.io/ \
		--version 1.13.0 \
		--namespace=kube-system 

delete-cilium:
	helm -n kube-system uninstall cilium
