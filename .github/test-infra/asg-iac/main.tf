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
  vpc_zone_identifier  = [aws_subnet.uds-package-gitlab-runner.id]

  launch_template {
    id      = aws_launch_template.uds-package-gitlab-runner.id
    version = "$Latest"
  }
}

resource "aws_security_group" "uds-package-gitlab-runner" {
  name        = "${var.name}-security-group"
  description = "Allow inbound traffic from GitHub runner"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.runner_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "uds-package-gitlab-runner" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  map_public_ip_on_launch = true
}
