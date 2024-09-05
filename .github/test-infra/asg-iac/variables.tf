variable "runner_ip" {
  description = "Public IP of the GitHub Actions runner"
  type        = string
}

variable "vpc_id" {
  description = "The VPC to create the ASG within"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR Block to take within the VPC"
  type        = string
  default     = "192.168.159.0/24"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "name" {
  description = "Name for the Autoscaling Group"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to scale in the ASG (must have git and gitlab-runner installed)"
  type        = string
}

variable "namespace" {
  description = "Namespace containing the GitLab Runner Service Account"
  type        = string
  default     = "gitlab-runner"
}

variable "service_account" {
  description = "Name of the GitLab Runner Service Account"
  type        = string
  default     = "gitlab-runner"
}

variable "permissions_boundary_name" {
  description = "The name of the permissions boundary for IAM resources.  This will be used for tagging and to build out the ARN."
  type        = string
  default     = null
}
