# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  s3_promo_web_hosting_bucket  = "${var.aws_account}.${var.aws_region}.promo-resources.ch.gov.uk"
  security_s3_data             = data.vault_generic_secret.security_s3_buckets.data
  promo_logs_bucket_name       = local.security_s3_data["s3-promo-logs-bucket-name"]
  promo_s3_logs_prefix         = "promo-s3-web-hosting-logs"
  promo_cloudfront_logs_prefix = "promo-cloudfront-logs"

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}