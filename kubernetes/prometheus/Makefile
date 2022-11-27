prom-deploy:
	helm upgrade -i prometheus prometheus \
		--repo https://prometheus-community.github.io/helm-charts \
		--namespace prometheus \
		-f helm-values.yaml \
		--create-namespace

prom-delete:
	helm -n prometheus uninstall prometheus && \
		kubectl delete ns prometheus


