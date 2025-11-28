variable "eks_host" {
  description = "The endpoint URL for the EKS cluster."
  type        = string
}

variable "eks_ca_cert" {
  description = "Base64 encoded certificate data for the EKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources are deployed."
  type        = string
}

variable "helm_chart_repo_url" {
  description = "The Git repository URL for the Helm chart (monorepo)."
  type        = string
  default     = "https://github.com/SerhiiMis/goit-devops-ci-cd.git"
}