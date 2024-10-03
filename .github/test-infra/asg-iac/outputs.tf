output "asg_arn" {
  value = aws_autoscaling_group.uds-package-gitlab-runner.arn
  description = "The ARN of the Autoscaling Group"
}

output "asg_role_arn" {
  value = aws_iam_role.asg_role.arn
  description = "The ARN of the ASG IRSA role"
}

output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
  description = "The IP Address of the jumpbox"
  sensitive = true
}

output "jumpbox_private_key" {
  value     = tls_private_key.jumpbox_tls_key.private_key_pem
  description = "The SSH Key for the jumpbox"
  sensitive = true
}
