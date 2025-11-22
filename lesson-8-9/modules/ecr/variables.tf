variable "ecr_name" {
  type    = string
  default = "lesson-7-ecr"
}
variable "scan_on_push" {
  type    = bool
  default = true
}
variable "aws_region" {
  type    = string
  default = "eu-central-1"
}
