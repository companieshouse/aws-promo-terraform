resource "vault_generic_secret" "s3" {
  path = "aws-accounts/${var.aws_account}/s3"

  data_json = <<EOT
{
  "s3_promo_web_hosting_bucket-id": "${module.s3_promo_web_hosting_bucket.s3_bucket_id}",
  "s3_promo_web_hosting_bucket-arn": "${module.s3_promo_web_hosting_bucket.s3_bucket_arn}",
  "s3_promo_web_hosting_bucket-name": "${local.s3_promo_web_hosting_bucket}",
  "s3_promo_cf_logs_bucket-id": "${module.cloudfront_logs_bucket.s3_bucket_id}",
  "s3_promo_cf_logs_bucket-arn": "${module.cloudfront_logs_bucket.s3_bucket_arn}",
  "s3_promo_cf_logs_bucket-name": "${local.s3_promo_cf_logs_bucket}"
}
EOT
}

resource "vault_generic_secret" "kms" {
  path = "aws-accounts/${var.aws_account}/kms-promo"

  data_json = <<EOT
{
  "promo-kms-key-arn": "${module.kms["promologs"].key_arn}"
}
EOT
}