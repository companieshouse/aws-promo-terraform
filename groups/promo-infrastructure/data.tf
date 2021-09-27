# ------------------------------------------------------------------------------
# Data
# ------------------------------------------------------------------------------
provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

data "vault_generic_secret" "security_s3" {
  path = "aws-accounts/security/s3"
}

data "aws_acm_certificate" "acm_cert" {
  provider = aws.acm_provider
  domain   = var.domain_cert_name
}