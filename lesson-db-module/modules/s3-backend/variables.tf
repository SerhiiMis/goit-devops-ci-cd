variable "bucket_name" {
  type    = string
  default = "lesson7-terraform-state-serhii-12345"
}

variable "dynamodb_table_name" {
  type    = string
  default = "terraform-locks"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}
