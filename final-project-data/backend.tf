terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "final-project-state-serhii-2025"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
