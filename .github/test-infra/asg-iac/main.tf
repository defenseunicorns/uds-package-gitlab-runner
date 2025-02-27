# Copyright 2024 Defense Unicorns
# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-Defense-Unicorns-Commercial

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name                 = "${var.name}-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = [for az_name in slice(data.aws_availability_zones.available.names, 0, min(length(data.aws_availability_zones.available.names), 3)) : az_name]
  public_subnets       = [for k, v in module.vpc.azs : cidrsubnet(module.vpc.vpc_cidr_block, 5, k)]
  enable_nat_gateway   = false

  instance_tenancy                  = "default"
  vpc_flow_log_permissions_boundary = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/${var.permissions_boundary_name}"

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_launch_template" "uds-package-gitlab-runner" {
  name_prefix   = "uds-package-gitlab-runner-"
  image_id      = var.ami_id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.uds-package-gitlab-runner.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-launch-template"
    }
  }
}

# AWS Fleeting Plugin: https://gitlab.com/gitlab-org/fleeting/plugins/aws#autoscaling-group-setup
resource "aws_autoscaling_group" "uds-package-gitlab-runner" {
  name                 = var.name
  desired_capacity     = 0
  max_size             = 10
  min_size             = 0
  vpc_zone_identifier  = module.vpc.public_subnets

  launch_template {
    id      = aws_launch_template.uds-package-gitlab-runner.id
    version = "$Latest"
  }
}

resource "aws_security_group" "uds-package-gitlab-runner" {
  name        = "${var.name}-security-group"
  description = "Allow inbound traffic from GitHub runner"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.runner_ip}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "jumpbox_tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jumpbox_key_pair" {
  key_name   = "${var.name}-jumpbox-ssh-key"
  public_key = tls_private_key.jumpbox_tls_key.public_key_openssh
}

resource "aws_instance" "jumpbox" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.jumpbox_key_pair.key_name

  tags = {
    Name = "${var.name}-jumpbox"
  }

  # Security group to allow SSH (port 22)
  vpc_security_group_ids = [aws_security_group.uds-package-gitlab-runner.id]
  subnet_id = module.vpc.public_subnets[0]

  associate_public_ip_address = true
}

resource "aws_route53_zone" "uds_dev" {
  name = "uds.dev"
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "my_domain" {
  zone_id = aws_route53_zone.uds_dev.id
  name    = "gitlab.uds.dev"
  type    = "A"
  ttl     = 300

  records = [aws_instance.jumpbox.private_ip]
}
