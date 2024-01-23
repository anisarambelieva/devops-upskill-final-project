resource "aws_ecr_repository" "ecr-repository" {
  name = var.ecr_repository_name
}