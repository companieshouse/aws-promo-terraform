# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  s3_promo_web_hosting_bucket = "${var.aws_account}.${var.aws_region}.promo_web_hosting"

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}