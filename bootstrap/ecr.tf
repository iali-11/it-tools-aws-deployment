resource "aws_ecr_repository" "it_tools_repo" {
  name                 = "it_tools_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}