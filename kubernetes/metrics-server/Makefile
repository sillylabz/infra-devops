deploy-metrics-server:
	helm upgrade -i metrics-server metrics-server \
		--repo https://kubernetes-sigs.github.io/metrics-server \
		--namespace metrics-server \
		--create-namespace \
		-f helm-values.yml 

delete-metrics-server:
	helm -n metrics-server uninstall metrics-server && \
		kubectl delete ns metrics-server

