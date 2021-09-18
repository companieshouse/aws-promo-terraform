# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  s3_promo_web_hosting_bucket      = "${var.aws_account}.${var.aws_region}.promo-resources.ch.gov.uk"
  s3_origin_id                     = "promo"
  s3_promo_logs_bucket             = "${var.aws_account}.${var.aws_region}.s3-promo-logs"
  s3_promo_web_hosting_logs_bucket = "${var.aws_account}.${var.aws_region}.promo-s3-web-hosting-logs"
  cw_promo_log_grp                 = "promo-cw-lg"
  promo_s3_logs_prefix             = "promo-s3-web-hosting-logs"
  promo_cloudfront_logs_prefix     = "promo-cloudfront-logs"

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}