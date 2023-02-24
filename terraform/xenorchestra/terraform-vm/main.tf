# Instruct terraform to download the provider on `terraform init`
terraform {
  required_providers {
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
      version = "~> 0.3.0"
    }
  }
}

# Configure the XenServer Provider
provider "xenorchestra" {
  url      = var.xen_host_url
  username = var.xen_username
  password = var.xen_password
}


data "xenorchestra_pool" "pool" {
  name_label = var.xen_pool
}

data "xenorchestra_sr" "local_storage" {
  name_label = var.xen_sr_name
  pool_id = data.xenorchestra_pool.pool.id
}


data "xenorchestra_template" "template" {
  name_label = var.vm_template_name
}

# data "xenorchestra_network" "net" {
#   name_label = "Pool-wide network associated with eth0"
# }

locals {
  vm_name = "${var.project_name}-server-${var.environment}"
}

resource "xenorchestra_cloud_config" "bar" {
  name     = "${local.vm_name}-config"
  template = "test"

}


resource "xenorchestra_cloud_config" "demo" {
  name = "cloud config name"
  template = <<EOF
#cloud-config

runcmd:
 - [ ls, -l, / ]
 - [ sh, -xc, "echo $(date) ': hello world!'" ]
 - [ sh, -c, echo "=========hello world'=========" ]
 - ls -l /root
EOF
}


resource "xenorchestra_vm" "bar" {
  memory_max       = var.vm_memory_max
  cpus             = var.vm_cpus
  cloud_config     = xenorchestra_cloud_config.demo.id
  name_label       = local.vm_name
  name_description = "${local.vm_name} for ${var.project_name}. managed by terraform, configured with ansible."
  template         = data.xenorchestra_template.template.id

  network {
    network_id = "Pool-wide network associated with eth0"
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_storage.id
    name_label = "${local.vm_name}-disk"
    //   name_description = "test centos 8 disk"
    size = var.vm_disk_size_in_bytes
  }
}



