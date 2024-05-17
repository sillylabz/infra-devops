deploy-ghrunners:
	helm upgrade -i --wait actions-runner-controller actions-runner-controller \
		--namespace actions-runner-system \
		--create-namespace \
		--repo https://actions-runner-controller.github.io/actions-runner-controller \
		-f helm-values.yml
             

delete-ghrunners:
	helm -n actions-runner-system uninstall actions-runner-controller && \
		kubectl delete ns actions-runner-system

