terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "lesson7-terraform-state-serhii-12345"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
