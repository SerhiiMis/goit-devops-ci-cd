variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "admin_iam_arns" {
  type    = list(string)
  default = ["arn:aws:iam::085710281301:root"] # Ваш Root ARN
}

variable "enable_admin_access" {
  type    = bool
  default = true
}