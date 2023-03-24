gitlab_url ?= "https://gitlab.com/"
runner_registration_token ?= "astryhs334etd"
runner_name ?= "gitlab-runner"

deploy-runner:
	helm upgrade -i ${runner_name} gitlab-runner \
		--repo https://charts.gitlab.io \
		--namespace gitlab-runner \
		--create-namespace \
		-f helm-values.yml \
		--set gitlabUrl=$(gitlab_url),runnerRegistrationToken=$(runner_registration_token) \

delete-runner:
	helm -n gitlab-runner uninstall ${runner_name}

