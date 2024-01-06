resource "aws_dynamodb_table" "newsletter-subcriptions-table" {
  name           = "newsletter-subscriptions"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Email"

  attribute {
    name = "Email"
    type = "S"
  }

  attribute {
    name = "Name"
    type = "S"
  }

  ttl {
    attribute_name = "TTL"
    enabled        = false
  }

  tags = {
    Name        = "newsletter-dynamodb-table"
    Project     = "Telerik Upskill"
    Environment = "production"
  }
}