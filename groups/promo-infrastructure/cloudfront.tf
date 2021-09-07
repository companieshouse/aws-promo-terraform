module "cloudfront_promo" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "2.7.0"

  comment             = "Promo Site CloudFront"
  enabled             = true
  is_ipv6_enabled     = false
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  origin = {
    something = {
      domain_name = module.s3_promo_web_hosting_bucket.s3_bucket_website_domain
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1"]
      }
    }

    s3_one = {
      domain_name = module.s3_promo_web_hosting_bucket.s3_bucket_website_domain
    }
  }

  default_cache_behavior = {
    target_origin_id       = "something"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }
}