terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket         = "lesson-5-terraform-state-085710281301"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
