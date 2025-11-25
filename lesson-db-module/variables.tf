variable "bucket_name" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "lesson-7-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.30"   
}

