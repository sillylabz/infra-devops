deploy-argo:
	helm upgrade -i argocd argo-cd \
		--namespace argocd \
		--create-namespace \
		--repo https://argoproj.github.io/argo-helm \
		--set crds.install=true \
		-f helm-values.yml

delete-argo:
	helm -n argocd uninstall argocd && \
		kubectl delete ns argocd

