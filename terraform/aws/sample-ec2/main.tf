resource "random_id" "asg_random" {
  byte_length = 4
}

# Instance IAM profile, roles and policies
resource "aws_iam_instance_profile" "asg_instance_profile" {
  name = "${var.application_name}-instance-profile-${var.environment}-${random_id.asg_random.hex}"
  role = aws_iam_role.asg_instance_role.name
}

resource "aws_iam_role" "asg_instance_role" {
  name = "${var.application_name}-instance-role-${var.environment}-${random_id.asg_random.hex}"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
    }
  )
}

resource "aws_iam_policy" "asg_instance_s3_policy" {
  name        = "${var.application_name}-s3-policy-${var.environment}-${random_id.asg_random.hex}"
  description = "iam access policy for ${var.project_name} ${var.application_name} instance access to s3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "asg_s3_policy_attach" {
  role       = aws_iam_role.asg_instance_role.name
  policy_arn = aws_iam_policy.asg_instance_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "asg_ssm_policy_attach" {
  role       = aws_iam_role.asg_instance_role.name
  policy_arn = data.aws_iam_policy.asg_ssm_instance_policy.arn
}


resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for ${var.project_name} ${var.application_name} autoscaling"
  custom_suffix    = "${var.application_name}-${var.environment}-${random_id.asg_random.hex}"

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# Security groups
resource "aws_security_group" "asg_sg" {
  name        = "${var.application_name}-sg-${var.environment}-${random_id.asg_random.hex}"
  description = "asg repo private security group"
  vpc_id      = data.aws_vpc.selected.id

  # Access from other security groups
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



module "s3_logging_bucket" {
  source  = "operatehappy/s3-bucket/aws"
  version = "1.2.0"
  name    = "${lower(local.s3_logging_bucket_name)}-logging--${random_id.asg_random.hex}"
  acl     = "log-delivery-write"

  force_destroy = true

  server_side_encryption_configuration = {
    sse_algorithm = "AES256"
  }
}


module "asg_elb" {
  source = "terraform-aws-modules/elb/aws"
  name   = "${var.application_name}-elb-${var.environment}-${random_id.asg_random.hex}"

  subnets         = [for s in data.aws_subnet.subnet_lists : s.id]
  security_groups = [aws_security_group.asg_sg.id]
  internal        = false

  listener = var.asg_elb_listeners

  health_check = {
    healthy_threshold   = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout             = var.elb_timeout
    target              = "TCP:22"
    interval            = var.elb_interval
  }

  tags = local.tags
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = "${var.application_name}-asg-${var.environment}"

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = var.health_check_type
  health_check_grace_period = var.asg_grace
  vpc_zone_identifier       = [for s in data.aws_subnet.subnet_lists : s.id]

  initial_lifecycle_hooks = var.asg_initial_lifecycle_hooks

  // initial_lifecycle_hook {
  //   for_each = var.asg_initial_lifecycle_hooks
  //   content {
  //     name                    = initial_lifecycle_hook.value.name
  //     default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
  //     heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
  //     lifecycle_transition    = initial_lifecycle_hook.value.lifecycle_transition
  //     notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
  //     notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
  //     role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
  //   }
  // }


  # Launch template
  lt_name                = "${var.application_name}-lt-${var.environment}"
  description            = "asg ec2 launch template for ${var.project_name}'s ${var.application_name} instances in ${var.environment}."
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id          = var.asg_ami_id
  instance_type     = var.asg_instance_type
  key_name          = var.asg_ssh_key_name
  user_data_base64  = base64encode(local.user_data)
  ebs_optimized     = true
  enable_monitoring = false

  block_device_mappings = var.asg_block_device_mappings

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { resourceType = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { resourceType = "Volume" }
    }
  ]

  tags = local.asg_tags

}


