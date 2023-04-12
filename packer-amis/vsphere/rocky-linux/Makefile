curr_dir = $(shell pwd)
vcenter_password ?= "vcenter-password"
ssh_password ?= "ssh-password"
script_name = ?= "setup.sh"

linux:
	packer build -force -on-error=ask \
		-var-file rocky-linux-clone.pkvars.hcl \
		-var-file vsphere-creds.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}" \
		-var "script_name=${script_name}" \
		rocky-linux-clone.pkr.hcl

linux-docker:
	docker run --rm -ti --name packer-build \
		-v ${curr_dir}:/workspace -w /workspace \
		-e PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
		hashicorp/packer:latest \
		build -force -on-error=cleanup \
		-var-file linux.pkvars.hcl \
		-var-file vsphere-vars.pkvars.hcl \
		-var "vcenter_password=${vcenter_password}" \
		-var "ssh_password=${ssh_password}" \
		-var "script_name=${script_name}" \
		linux.pkr.hcl


