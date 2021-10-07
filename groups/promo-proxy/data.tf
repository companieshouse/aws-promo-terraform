
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

data "aws_subnet_ids" "endpoint" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-endpoint-*"]
  }
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "promo_proxy_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/ec2"
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "aws_kms_key" "ebs" {
  key_id = "alias/${var.account}/${var.region}/ebs"
}

# ------------------------------------------------------------------------------
# Promo Proxy Frontend data
# ------------------------------------------------------------------------------
data "aws_ami" "promo_proxy_fe" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.fe_ami_name == "promo-proxy-*" ? true : false

  filter {
    name = "name"
    values = [
      var.fe_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}
