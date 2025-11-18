terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

# modules
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "lesson-7-terraform-state-<your-unique>" # optional if module creates; or reuse existing
  dynamodb_table_name = "terraform-locks"
  aws_region  = var.aws_region
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
  availability_zones = ["eu-central-1a","eu-central-1b","eu-central-1c"]
  vpc_name           = "lesson-7-vpc"
}

module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-7-ecr"
  scan_on_push= true
}

