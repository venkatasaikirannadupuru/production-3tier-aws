resource "aws_ecr_repository" "app" {
  name                 = "production-3tier-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "production-3tier-app"
  }
}

