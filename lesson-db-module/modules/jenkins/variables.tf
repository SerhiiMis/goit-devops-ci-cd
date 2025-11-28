# modules/jenkins/variables.tf

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

variable "ecr_repository_url" {
  description = "The full URL of the ECR repository (for use in Jenkinsfile)."
  type        = string
}

variable "ecr_name" {
  description = "The name of the ECR repository."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources are deployed."
  type        = string
}

variable "jenkins_admin_password" {
  description = "Initial Jenkins admin password."
  type        = string
  default     = "password123" 
  sensitive   = true
}