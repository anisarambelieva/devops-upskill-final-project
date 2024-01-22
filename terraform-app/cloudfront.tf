# resource "aws_cloudfront_distribution" "default" {
#   comment         = "CloudFront Distribution"
#   enabled         = true
#   is_ipv6_enabled = true
#   aliases         = ["${var.domain_name}"]

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
#     cached_methods         = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id       = aws_alb.alb.name
#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = true
#       headers      = ["*"]

#       cookies {
#         forward = "all"
#       }
#     }
#   }

#   origin {
#     domain_name = aws_alb.alb.dns_name
#     origin_id   = aws_alb.alb.name

#     custom_origin_config {
#       origin_read_timeout      = 60
#       origin_keepalive_timeout = 60
#       http_port                = 80
#       https_port               = 443
#       origin_protocol_policy   = "https-only"
#       origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
#     }
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn      = "arn:aws:acm:eu-west-1:933920645082:certificate/a98f1382-15d7-4f56-9e67-30b9f10471a3"
#     minimum_protocol_version = "TLSv1.1_2016"
#     ssl_support_method       = "sni-only"
#   }
# }