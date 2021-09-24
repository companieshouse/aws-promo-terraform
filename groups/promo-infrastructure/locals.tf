# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  s3_promo_web_hosting_bucket      = "${var.aws_account}.${var.aws_region}.promo-resources.ch.gov.uk"
  s3_origin_id                     = "promo"
  s3_promo_cf_logs_bucket          = "${var.aws_account}.${var.aws_region}.promo-s3-cloudfront-logs"
  s3_promo_web_hosting_logs_bucket = "${var.aws_account}.${var.aws_region}.promo-s3-web-hosting-logs"
  account_ids                      = data.vault_generic_secret.account_ids.data
  security_s3                      = data.vault_generic_secret.security_s3.data

  kms_customer_master_keys = {
    promo = {
      description             = "Promo encryption key"
      deletion_window_in_days = 30
      enable_key_rotation     = true
      is_enabled              = true
    }
  }

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}