resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true
  origin {
    domain_name = module.alb.lb_dns_name
    origin_id   = module.alb.lb_dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = module.alb.lb_dns_name
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}