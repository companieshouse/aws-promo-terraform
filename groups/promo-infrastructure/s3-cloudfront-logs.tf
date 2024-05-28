module "cloudfront_logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.0.1"

  bucket        = local.s3_promo_cf_logs_bucket
  attach_policy = "false"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled    = true
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms["promologs"].key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "LogRetention"
      enabled = true
      expiration = {
        days = 365
      }
      noncurrent_version_expiration = {
        days = 365
      }
    }
  ]

  acl = null # Grant conflicts with default of `acl = "private"` so set to null to use grants
  grant = [
    {
      type        = "Group"
      permission  = "READ_ACP"
      uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
    },
    {
      type        = "Group"
      permission  = "WRITE"
      uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
    },
    {
      type        = "CanonicalUser"
      permission  = "FULL_CONTROL"
      id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    }
  ]

  tags = {
    "Name" = "${var.application}-cf-logs"
    "Env"  = var.environment
  }
}