data "aws_s3_bucket" "oidc_bucket" {
  bucket = "govcloud-ci-oidc"
}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

## This will create a policy for the Autoscaling Group (https://gitlab.com/gitlab-org/fleeting/plugins/aws#setting-an-iam-policy)
resource "aws_iam_policy" "asg_policy" {
  name        = "${var.name}-policy"
  path        = "/"
  description = "IRSA policy to access the autoscaling group."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
        ]
        Resource = aws_autoscaling_group.uds-package-gitlab-runner.arn
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "ec2:DescribeInstances",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:GetPasswordData",
          "ec2-instance-connect:SendSSHPublicKey",
        ]
        Resource = "arn:${data.aws_partition.current.partition}:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/*"
        Condition = {
            StringEquals = {
                "ec2:ResourceTag/aws:autoscaling:groupName": aws_autoscaling_group.uds-package-gitlab-runner.name
            }
        }
      }
    ]
  })
}

## Create service account role
resource "aws_iam_role" "asg_role" {
  name = "${var.name}-asg-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
          "Federated" : "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${data.aws_s3_bucket.oidc_bucket.bucket_regional_domain_name}"
        }
        "Condition" : {
          "StringEquals" : {
            "${data.aws_s3_bucket.oidc_bucket.bucket_regional_domain_name}:aud" : "irsa",
            "${data.aws_s3_bucket.oidc_bucket.bucket_regional_domain_name}:sub" : "system:serviceaccount:${var.namespace}:${var.service_account}"
          }
        }
      }
    ]
  })

  permissions_boundary = var.permissions_boundary_name

  tags = {
    PermissionsBoundary = var.permissions_boundary_name
  }
}

resource "aws_iam_role_policy_attachment" "asg_policy_attach" {
  role       = aws_iam_role.asg_role.name
  policy_arn = aws_iam_policy.asg_policy.arn
}
