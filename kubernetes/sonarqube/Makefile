deploy-sonar:
	helm upgrade -i sonarqube sonarqube \
		--namespace sonarqube \
		--create-namespace \
		--repo https://SonarSource.github.io/helm-chart-sonarqube \
		--version '~8' \
		-f helm-values.yml 

delete-sonar:
	helm -n sonarqube uninstall sonarqube && \
		kubectl delete ns sonarqube

