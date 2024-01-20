resource "aws_dynamodb_table" "newsletter-subcriptions-table" {
  hash_key       = "Email"

  attribute {
    name = "Email"
    type = "S"
  }

  tags = {
    Name        = "newsletter-dynamodb-table"
    Project     = "Telerik Upskill"
    Environment = "production"
  }
}