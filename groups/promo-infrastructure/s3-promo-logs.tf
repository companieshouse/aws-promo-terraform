module "cloudfront_logs" {
  source  = "fmasuhr/cloudfront-logs/aws"
  version = "1.3.1"

  bucket_name = local.s3_promo_logs_bucket
  name        = local.cw_promo_log_grp
  retention   = "365"
  tags = {
    "Name" = "${var.application}-logs"
    "Env"  = var.environment
  }
}