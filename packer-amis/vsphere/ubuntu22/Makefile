curr_dir = $(shell pwd)
vcenter_password ?= "vcenter-password"
ssh_password ?= "ssh-password"

ubuntu22:
	packer build -force -on-error=ask \
		-var-file ubuntu22-clone.pkvars.hcl \
		-var-file vsphere-creds.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}"
		ubuntu22-clone.pkr.hcl

ubuntu22-docker:
	docker run --rm -ti --name packer-build \
		-v ${curr_dir}:/workspace -w /workspace \
		-e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
		hashicorp/packer:latest \
		build -force -on-error=cleanup \
		-var-file ubuntu22.pkvars.hcl \
		-var-file vsphere-vars.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}" \
		ubuntu22.pkr.hcl

