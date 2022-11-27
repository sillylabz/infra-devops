gitlab_url ?= "https://gitlab.com"
runner_registration_token ?= astryhs334etd

deploy-runner:
	helm upgrade -i gitlab-runner gitlab-runner \
		--repo https://charts.gitlab.io \
		--namespace gitlab-runner \
		--create-namespace \
		-f helm-values.yml \
		--set gitlabUrl=$(gitlab_url),runnerRegistrationToken=$(runner_registration_token) 

