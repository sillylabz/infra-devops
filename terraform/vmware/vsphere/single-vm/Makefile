# project_name = sample

init:
	terraform init 

plan:
	terraform plan -var-file=shared_vars.tfvars

apply:
	terraform apply -var-file=shared_vars.tfvars -auto-approve

destroy:
	terraform destroy -var-file=shared_vars.tfvars -auto-approve

outputs:
	terraform output

fmt:
	terraform fmt

validate:
	terraform validate



# docker
docker-init:
	docker run -ti --rm --name terraform -v ~/.aws:/root/.aws -v ${PWD}:/root hernanku/devops-cli /bin/bash -c "cd /root && terraform init"

docker-plan:
	docker run -ti --rm --name terraform -v ~/.aws:/root/.aws -v ${PWD}:/root hernanku/devops-cli /bin/bash -c "cd /root && source setenv.sh && terraform plan -var-file=shared_vars.tfvars"

docker-apply:
	docker run -ti --rm --name terraform -v ~/.aws:/root/.aws -v ${PWD}:/root hernanku/devops-cli /bin/bash -c "cd /root && source setenv.sh && terraform apply -var-file=shared_vars.tfvars -auto-approve"

docker-destroy:
	docker run -ti --rm --name terraform -v ~/.aws:/root/.aws -v ${PWD}:/root hernanku/devops-cli /bin/bash -c "cd /root && source setenv.sh && terraform destroy -var-file=shared_vars.tfvars -auto-approve"

docker-outputs:
	docker run -ti --rm --name terraform -v ~/.aws:/root/.aws -v ${PWD}:/root hernanku/devops-cli /bin/bash -c "cd /root && terraform output"

docker-fmt:
	docker run -ti --rm --name terraform -v ~/.aws:/root/.aws -v ${PWD}:/root hernanku/devops-cli /bin/bash -c "cd /root && terraform fmt"

docker-validate:
	docker run -ti --rm --name terraform -v ~/.aws:/root/.aws -v ${PWD}:/root hernanku/devops-cli /bin/bash -c "cd /root && terraform validate"
