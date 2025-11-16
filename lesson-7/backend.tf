terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "lesson-5-terraform-state-serhii-2025" 
    key            = "lesson-7/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
