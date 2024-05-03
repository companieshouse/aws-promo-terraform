
# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.13.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.3, < 4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 2.0.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"
    parameters = {
      password = var.vault_password
    }
  }
}

####################################################################################################
## S3 access logging
####################################################################################################

module "s3_access_logging_website" {
  source = "git@github.com:companieshouse/terraform-modules//aws/s3_access_logging?ref=tags/1.0.264"

  aws_account           = var.aws_account
  aws_region            = var.aws_region
  source_s3_bucket_name = local.s3_promo_web_hosting_bucket
}

module "s3_access_logging_cloudfront" {
  source = "git@github.com:companieshouse/terraform-modules//aws/s3_access_logging?ref=tags/1.0.264"

  aws_account           = var.aws_account
  aws_region            = var.aws_region
  source_s3_bucket_name = local.s3_promo_cf_logs_bucket
}
