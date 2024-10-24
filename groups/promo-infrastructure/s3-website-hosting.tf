module "s3_promo_web_hosting_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.1"

  bucket = local.s3_promo_web_hosting_bucket
  acl    = "private"

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
}

# ------------------------------------------------------------------------------
# Policies
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "s3_promo_web_hosting_bucket_policy" {
  bucket = module.s3_promo_web_hosting_bucket.s3_bucket_id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${local.s3_promo_web_hosting_bucket}/*",
            "Condition": {
                "StringEquals": {
                  "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
                }
            }
        },
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${local.s3_promo_web_hosting_bucket}",
                "arn:aws:s3:::${local.s3_promo_web_hosting_bucket}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}
