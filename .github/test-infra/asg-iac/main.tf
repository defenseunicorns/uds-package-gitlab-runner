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

  tags = {
    Name = "${var.name}-subnet"
  }
}

resource "tls_private_key" "jumpbox_tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jumpbox_key_pair" {
  key_name   = "jumpbox-ssh-key"
  public_key = tls_private_key.jumpbox_tls_key.public_key_openssh
}

resource "aws_instance" "jumpbox" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.jumpbox_key_pair.key_name

  tags = {
    Name = "Jumpbox"
  }

  # Security group to allow SSH (port 22)
  vpc_security_group_ids = [aws_security_group.uds-package-gitlab-runner.id]
  subnet_id = aws_subnet.uds-package-gitlab-runner.id
}

resource "aws_route53_zone" "uds_dev" {
  name = "uds.dev"
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "my_domain" {
  zone_id = aws_route53_zone.uds_dev.id
  name    = "gitlab.uds.dev"
  type    = "A"
  ttl     = 300

  records = [aws_instance.jumpbox.private_ip]
}
