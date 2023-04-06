curr_dir = $(shell pwd)
vcenter_password ?= "vcenter-password"
ssh_password ?= "ssh-password"

ubuntu:
	packer build -force -on-error=ask \
		-var-file ubuntu.pkvars.hcl \
		-var-file vsphere-creds.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}"
		ubuntu.pkr.hcl

ubuntu-docker:
	docker run --rm -ti --name packer-build \
		-v ${curr_dir}:/workspace -w /workspace \
		-e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
		hashicorp/packer:latest \
		build -force -on-error=cleanup \
		-var-file ubuntu.pkvars.hcl \
		-var-file vsphere-vars.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}" \
		ubuntu.pkr.hcl

