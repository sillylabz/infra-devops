packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "golden-ami" {
  # skip_create_ami  = true
  region                = "us-east-1"
  vpc_id                = "vpc-0a62cca0a1507beac"
  force_deregister      = true
  force_delete_snapshot = true
  ami_name              = "demo-qa-ami-{{timestamp}}"
  # iam_instance_profile      = "AmazonSSMRoleForInstancesQuickSetup"
  instance_type             = "t2.medium"
  source_ami                = ""
  subnet_id                 = ""
  communicator              = "ssh"
  ssh_username              = "ec2-user"
  ssh_clear_authorized_keys = true
  # security_group_id         = ""
  ami_users = [
    "202334955716",
    "665081764253",
    "295615438328"
  ]
  # ssh_keypair_name          = "aws-packer-key"
  ssh_interface             = "private_ip"
  snapshot_users = [
    "202334955716",
    "665081764253",
    "295615438328"
  ]
  // region_kms_key_ids = []

  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 200
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = ""
  }
  run_tags = var.tags
  run_volume_tags = var.tags

  tags = var.tags
}

build {
  sources = [
    "source.amazon-ebs.golden-ami"
  ]

  provisioner "ansible" {
    playbook_file = "playbook.yaml"
    # ansible_env_vars= [ "ANSIBLE_DEBUG=1" ]
  }

  # post-processor "manifest" {
  #   output     = "manifest.json"
  #   strip_path = true
  # }
}

