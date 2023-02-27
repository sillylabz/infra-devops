install-driver:
	helm upgrade -i calico tigera-operator \
		--repo https://docs.tigera.io/calico/charts \
		--namespace tigera-operator \
		--create-namespace \
		-f values.yml 

