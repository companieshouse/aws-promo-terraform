module "s3_promo_web_hosting_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.1.0"

  bucket = local.s3_promo_web_hosting_bucket
  acl    = "private"

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
    index_document = "index.shtml"
    error_document = "error.shtml"

    routing_rules = <<EOF
[
  {
    "Condition": {
        "KeyPrefixEquals": "arefiling/"
    },
    "Redirect": {
        "HostName": "gov.uk",
        "Protocol": "https",
        "ReplaceKeyPrefixWith": "file-your-confirmation-statement-with-companies-house/"
    }
  },
  {
    "Condition": {
        "KeyPrefixEquals": "freedominformation/freedominfo.shtml"
    },
    "Redirect": {
        "HostName": "gov.uk",
        "Protocol": "https",
        "ReplaceKeyPrefixWith": "government/organisations/companies-house/about/personal-information-charter"
    }
  },
  {
    "Condition": {
        "KeyPrefixEquals": "pressDesk/introduction.shtml"
    },
    "Redirect": {
        "HostName": "gov.uk",
        "Protocol": "https",
        "ReplaceKeyPrefixWith": "government/organisations/companies-house/about/media-enquiries"
    }
  }
]
EOF
  }
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
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${local.s3_promo_web_hosting_bucket}/*",
            "Condition": {
                "StringEquals": {
                    "aws:UserAgent": "${var.cloudfront-authentication-user-agent}"
                }
            }

        }
    ]
}
POLICY
}