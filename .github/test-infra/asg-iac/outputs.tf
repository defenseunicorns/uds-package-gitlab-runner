output "asg_arn" {
  value = aws_autoscaling_group.uds-package-gitlab-runner.arn
  description = "The ARN of the Autoscaling Group"
}

output "asg_role_arn" {
  value = aws_iam_role.asg_role.arn
  description = "The ARN of the ASG IRSA role"
}
