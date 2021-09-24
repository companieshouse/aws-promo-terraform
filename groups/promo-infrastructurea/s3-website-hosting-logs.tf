module "s3_promo_web_hosting_logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.1.0"

  bucket        = local.s3_promo_web_hosting_logs_bucket
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
        kms_master_key_id = module.kms["promo"].key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "LogRetention"
      enabled = true
      expiration = {
        days = 364
      }
      noncurrent_version_expiration = {
        days = 365
      }
    }
  ]

  acl = null # Grant conflicts with default of `acl = "private"` so set to null to use grants
  grant = [{
    type        = "Group"
    permissions = ["READ_ACP", "WRITE"]
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
    }
  ]

  logging = {
    target_bucket = local.s3_promo_web_hosting_logs_bucket
  }

  tags = {
    "Name" = "${var.application}-s3-web-hosting-logs"
    "Env"  = var.environment
  }
}