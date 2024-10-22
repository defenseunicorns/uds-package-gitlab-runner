# Copyright 2024 Defense Unicorns
# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-Defense-Unicorns-Commercial

variable "runner_ip" {
  description = "Public IP of the GitHub Actions runner"
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
