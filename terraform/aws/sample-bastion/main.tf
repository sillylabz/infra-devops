# Remote state
// terraform {
//   backend "s3" {
//     bucket = var.s3_backend_bucket_name
//     key    = "asg-poc/terraform/state/terraform.tfstate"
//     region = "us-east-1"
//   }
// }

provider "aws" {
  region     = var.aws_region
  // access_key = var.access_key
  // secret_key = var.secret_key
  // token = var.access_token
}


# #Security groups
# Public Security Group
resource "aws_security_group" "demo_sg" {
  name        = "${var.project_name}-sg-${var.environment}"
  description = "Used for private instances"
  vpc_id      = data.aws_vpc.vpc.id

  # Access from other security groups
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  ingress {
    description = "ec2 instance dev ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#---------compute-----------


#load balancer
resource "aws_elb" "demo_elb" {
  name = "${var.project_name}-elb-${var.environment}"

  subnets = [for s in data.aws_subnet.public_subnet_list : s.id]

  security_groups = [aws_security_group.demo_sg.id]

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
    target              = "TCP:22"
    interval            = var.elb_interval
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = merge(
    {
      Name = "${var.project_name}-elb-dev"
    },
    local.global_tags
  )
}

#launch configuration
resource "aws_launch_configuration" "demo_lc" {
  name_prefix          = "${var.project_name}-lc-${var.environment}-"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.demo_sg.id]
  iam_instance_profile = var.iam_instance_profile
  key_name             = var.key_name
  user_data            = file("userdata")

  lifecycle {
    create_before_destroy = true
  }
}

#ASG 
resource "aws_autoscaling_group" "demo_asg" {
  name                      = "${var.project_name}-asg-${var.environment}"
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  health_check_grace_period = var.asg_grace
  health_check_type         = var.asg_hct
  desired_capacity          = var.asg_cap
  force_delete              = true
  load_balancers            = [aws_elb.demo_elb.id]

  vpc_zone_identifier = [for s in data.aws_subnet.public_subnet_list : s.id]

  launch_configuration = aws_launch_configuration.demo_lc.name

  tag {
    key                 = "Name"
    value               = "${var.project_name}-instance-${var.environment}"
    propagate_at_launch = true
  }
  
  dynamic "tag" {
    for_each = var.cluster_extra_tags

    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


