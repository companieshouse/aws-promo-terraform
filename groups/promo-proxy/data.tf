data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-public-*"]
  }
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_cert_name
}