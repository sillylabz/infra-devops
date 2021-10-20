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
}


data "xenorchestra_template" "template" {
  name_label = var.vm_template_name
}

locals {
  vm_name = "${var.project_name}-server-${var.environment}"
}

resource "xenorchestra_cloud_config" "bar" {
  name     = var.xen_cloud_config_name
  template = file("${path.module}/linux-cloud-config.cfg")
}

resource "xenorchestra_vm" "bar" {
  memory_max       = var.vm_memory_max
  cpus             = var.vm_cpus
  cloud_config     = xenorchestra_cloud_config.bar.id
  name_label       = local.vm_name
  name_description = "${local.vm_name} for ${var.project_name}. managed by terraform, configured with ansible."
  template         = data.xenorchestra_template.template.id

  network {
    network_id = var.xen_network_id
  }

  disk {
    sr_id      = data.xenorchestra_sr.local_storage.id
    name_label = "${local.vm_name}-disk"
    //   name_description = "test centos 8 disk"
    size = var.vm_disk_size_in_bytes
  }
}



