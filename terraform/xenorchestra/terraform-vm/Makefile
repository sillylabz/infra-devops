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
