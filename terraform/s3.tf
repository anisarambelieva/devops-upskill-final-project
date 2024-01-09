resource "aws_s3_bucket" "terraform-backend-bucket" {
  bucket = var.terraform_backend_bucket
}

resource "aws_s3_bucket_versioning" "terraform-backend-bucket-versioning" {
  bucket = aws_s3_bucket.terraform-backend-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "codepipeline-artifacts-bucket" {
  bucket = var.codepipeline-artifacts-bucket
}

resource "aws_s3_bucket_versioning" "codepipeline-artifacts-bucket-versioning" {
  bucket = aws_s3_bucket.codepipeline-artifacts-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}