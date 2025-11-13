output "s3_bucket" {
  value = module.s3_backend.s3_bucket_id
}

output "dynamodb_table" {
  value = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}
