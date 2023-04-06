curr_dir = $(shell pwd)
vcenter_password ?= "vcenter-password"
ssh_password ?= "ssh-password"

ubuntu20-clone:
	packer build -force -on-error=ask \
		-var-file ubuntu20-clone.pkvars.hcl \
		-var-file vsphere-creds.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}"
		ubuntu20-clone.pkr.hcl

ubuntu20-clone-docker:
	docker run --rm -ti --name packer-build \
		-v ${curr_dir}:/workspace -w /workspace \
		-e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
		hashicorp/packer:latest \
		build -force -on-error=cleanup \
		-var-file ubuntu20.pkvars.hcl \
		-var-file vsphere-vars.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}" \
		ubuntu20.pkr.hcl


