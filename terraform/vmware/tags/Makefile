vsphere_password ?= "vsphere-password"

init:
	terraform init
plan:
	TF_VAR_vsphere_password=$(vsphere_password) terraform plan

apply:
	TF_VAR_vsphere_password=$(vsphere_password) terraform apply -auto-approve

destroy:
	TF_VAR_vsphere_password=$(vsphere_password) terraform destroy -auto-approve

fmt:
	terraform fmt

validate:
	TF_VAR_vsphere_password=$(vsphere_password) terraform validate


