variable "runner_ip" {
  description = "Public IP of the GitHub Actions runner"
  type        = string
}

variable "vpc_id" {
  description = "The VPC to create the ASG within"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "name" {
  description = "Name for the Autoscaling Group"
  type        = string
}

variable "namespace" {
  description = "Namespace containing the GitLab Runner Service Account"
  type        = string
}

variable "service_account" {
  description = "Name of the GitLab Runner Service Account"
  type        = string
}

variable "permissions_boundary_name" {
  description = "The name of the permissions boundary for IAM resources.  This will be used for tagging and to build out the ARN."
  type        = string
  default     = null
}
