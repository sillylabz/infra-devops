deploy-prom:
	helm upgrade -i prometheus prometheus \
		--repo https://prometheus-community.github.io/helm-charts \
		--namespace prometheus \
		-f helm-values.yaml \
		--create-namespace

delete-prom:
	helm -n prometheus uninstall prometheus && \
		kubectl delete ns prometheus


