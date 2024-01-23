resource "aws_dynamodb_table" "newsletter-subcriptions-table" {
  name           = "newsletter-subscriptions"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "email"

  attribute {
    name = "email"
    type = "S"
  }

  tags = {
    Name        = "newsletter-dynamodb-table"
    Project     = "Telerik Upskill"
    Environment = "production"
  }
}