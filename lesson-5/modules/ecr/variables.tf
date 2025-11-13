variable "ecr_name" {
  type = string
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}
