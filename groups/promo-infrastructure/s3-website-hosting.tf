module "s3_promo_web_hosting_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.1.0"

  bucket        = local.s3_promo_web_hosting_bucket
  acl           = "public-read"
  attach_policy = "true"
  policy        = data.aws_iam_policy_document.s3_promo_web_hosting_bucket_policy.json

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

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

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  logging = {
    target_bucket = local.promo_logs_bucket_name
    target_prefix = local.promo_s3_logs_prefix
  }
}

# ------------------------------------------------------------------------------
# Policies
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "s3_promo_web_hosting_bucket_policy" {
  statement {
    sid = "PublicRead"

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::${local.s3_promo_web_hosting_bucket}/*"
    ]
  }
}