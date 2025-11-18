terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = var.bucket_name
    key            = "terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = var.dynamodb_table_name
    encrypt        = true
  }
}
