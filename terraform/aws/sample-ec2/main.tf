# Instance IAM profile, roles and policies
resource "aws_iam_instance_profile" "asg_instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.asg_instance_role.name
}

resource "aws_iam_role" "asg_instance_role" {
  name = "${var.project_name}-instance-role"
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
  name        = "${var.project_name}-s3-policy"
  description = "asg s3 access policy"

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


# Security groups
resource "aws_security_group" "asg_private_sg" {
  name        = "${var.project_name}-private-sg"
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


#load balancer
resource "aws_elb" "asg_elb" {
  name = "${var.project_name}-elb"

  subnets = [for s in data.aws_subnet.subnet_private_lists : s.id]

  security_groups = [aws_security_group.asg_private_sg.id]

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = var.elb_healthy_threshold
    unhealthy_threshold = var.elb_unhealthy_threshold
    timeout             = var.elb_timeout
    target              = var.elb_health_target
    interval            = var.elb_interval
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = local.tags_as_map
}


module "asg_ec2" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = "${var.project_name}-asg"
  use_name_prefix = false

  max_size                  = var.asg_max
  min_size                  = var.asg_min
  health_check_grace_period = var.asg_grace
  health_check_type         = var.asg_hct
  wait_for_capacity_timeout = 0
  vpc_zone_identifier       = [for s in data.aws_subnet.subnet_private_lists : s.id]
  load_balancers = [aws_elb.asg_elb.name]


  # launch template
  lt_name                = "${var.project_name}-lt"
  description            = "asg ec2 launch template for ${var.project_name} instances."
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id          = data.aws_ami.amazon_linux.id
  instance_type     = var.asg_instance_type
  key_name = var.asg_ssh_key_name
  // user_data_base64  = base64encode(local.user_data)
  ebs_optimized     = true
  enable_monitoring = true

  block_device_mappings = var.asg_block_device_mappings

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  // cpu_options = {
  //   core_count       = 1
  //   threads_per_core = 1
  // }

  credit_specification = {
    cpu_credits = "standard"
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [aws_security_group.asg_private_sg.id]
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = merge({ WhatAmI = "Instance" }, local.tags_as_map)
    },
    {
      resource_type = "volume"
      tags          = merge({ WhatAmI = "Volume" }, local.tags_as_map)
    }
  ]

  tags        = local.tags
  tags_as_map = local.tags_as_map

}



