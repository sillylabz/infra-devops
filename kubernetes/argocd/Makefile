argo-deploy:
	helm upgrade -i argocd argo-cd \
		--namespace argocd \
		--create-namespace \
		--repo https://argoproj.github.io/argo-helm \
		--set crds.install=true \
		-f helm-values.yml

argo-delete:
	helm -n argocd uninstall argocd && \
		kubectl delete ns argocd

