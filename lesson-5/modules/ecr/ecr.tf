resource "aws_ecr_repository" "this" {
  name                 = var.ecr_name
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = var.ecr_name
  }
}
