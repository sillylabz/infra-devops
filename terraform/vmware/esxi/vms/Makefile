# project_name = sample

init:
	terraform init 

plan:
	terraform plan -var-file=shared_vars.tfvars

apply:
	terraform apply \
		-var-file=shared_vars.tfvars \
		-auto-approve && \
		sleep 120 && \ 
		terraform refresh -var-file=shared_vars.tfvars

destroy:
	terraform destroy -var-file=shared_vars.tfvars -auto-approve

outputs:
	terraform output

fmt:
	terraform fmt

validate:
	terraform validate
