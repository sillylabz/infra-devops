provider "aws" {
  region = "us-east-1"
}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
// data "aws_vpc" "default" {
//   default = true
// }

resource "aws_security_group" "rds_sg" {
  name        = "rds sg"
  description = "rds sg"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "rds ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "rds all ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for s in data.aws_subnet.private_subnet_list: s.cidr_block]
  }

  ingress {
    description = "rds all ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["73.128.10.169/32"]
  }

  egress {
    description = "rds all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}


#####
# DB
#####
module "db" {
  source = "../modules/aws-rds"

  identifier = "aurora-demodb"

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine            = "mysql"
  engine_version    = "5.7.23"
  instance_class    = "db.r5.large"
  allocated_storage = 30
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name     = "demodb"
  username = "user"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  multi_az = true

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = var.tags

  enabled_cloudwatch_logs_exports = ["error", "general"]

  # DB subnet group
  subnet_ids = [for s in data.aws_subnet.private_subnet_list: s.id]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "aurora-demodb-snapshot"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  // options = [
  //   {
  //     option_name = "Timezone"

  //     option_settings = [
  //       {
  //         name  = "TIME_ZONE"
  //         value = "UTC"
  //       },
  //     ]
  //   },
  // ]
}
