resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = module.s3_promo_web_hosting_bucket.s3_bucket_bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.promo.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Promo CloudFront service"
  default_root_object = "index.shtml"

  logging_config {
    include_cookies = false
    bucket          = "${local.s3_promo_cf_logs_bucket}.s3.amazonaws.com"
  }

  aliases = var.environment == "live" ? ["resources.${var.domain_name}"] : ["${var.account}-resources.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.gov_uk_redirect.arn
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "*.shtml"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.gov_uk_redirect.arn
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "*.html"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.acm_cert.arn
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }

  web_acl_id = module.promo_cf_waf.web_acl_arn

  depends_on = [module.cloudfront_logs_bucket]

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 404
    response_page_path    = "/errors/error404.html"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 500
    response_code         = 500
    response_page_path    = "/errors/error500.html"
  }
}

resource "aws_cloudfront_origin_access_control" "promo" {
  name                              = "promo-${var.aws_account}-control"
  description                       = "Origin access control for access to promo assets in S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "gov_uk_redirect" {
  name    = "promo-${var.aws_account}-gov-uk-redirect"
  runtime = "cloudfront-js-2.0"
  comment = "Return a 301 redirect to a gov.uk URL for specific client request paths"
  publish = true
  code    = file("${path.module}/functions/gov_uk_redirect.js")
}
