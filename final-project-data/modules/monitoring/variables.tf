variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "eks_host" {
  description = "The endpoint URL for the EKS cluster."
  type        = string
}

variable "eks_ca_cert" {
  description = "Base64 encoded certificate data for the EKS cluster."
  type        = string
}