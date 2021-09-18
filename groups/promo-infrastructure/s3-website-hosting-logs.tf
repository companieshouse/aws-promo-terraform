module "s3_promo_web_hosting_logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.1.0"

  bucket        = local.s3_promo_web_hosting_logs_bucket
  attach_policy = "false"
  #policy        = data.aws_iam_policy_document.s3_access_logs_bucket_policy.json

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
        sse_algorithm = "AES256"
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
  grant = [{
    type        = "Group"
    permissions = ["READ_ACP", "WRITE"]
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
    }
  ]

  logging = {
    target_bucket = local.s3_promo_web_hosting_logs_bucket
    #target_prefix = local.s3_access_logs_prefix
  }

  tags = {
    "Name" = "${var.application}-s3-web-hosting-logs"
    "Env"  = var.environment
  }
}