resource "aws_s3_bucket" "terraform-backend-bucket" {
  bucket = var.terraform_backend_bucket
}

resource "aws_s3_bucket_versioning" "terraform-backend-bucket-versioning" {
  bucket = aws_s3_bucket.terraform-backend-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}