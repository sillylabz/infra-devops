deploy-jenkins:
	kubectl apply -f jenkins-ns.yml && \
		kubectl apply -f jenkins-pvc.yml && \
		helm upgrade -i jenkins jenkins \
			--repo https://charts.jenkins.io \
			--namespace jenkins \
			--create-namespace \
			-f helm-values.yml && \
		kubectl apply -f jenkins-ingress.yml 


delete-jenkins:
	helm -n jenkins uninstall jenkins && \
		kubectl delete -f jenkins-pvc.yml && \
		kubectl delete -f jenkins-ingress.yml && \
		kubectl delete -f jenkins-ns.yml

