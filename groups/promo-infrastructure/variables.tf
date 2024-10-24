
# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

variable "kms_customer_master_keys" {
  description = "Map of KMS customer master keys and key policies to be created"
  type        = map(any)
  default     = {}
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

# ------------------------------------------------------------------------------
# CloudFront Variables
# ------------------------------------------------------------------------------

variable "domain_cert_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "domain_name" {
  type        = string
  default     = "companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

# ------------------------------------------------------------------------------
# CloudFront WAF Variables
# ------------------------------------------------------------------------------

variable "promo_cf_ipsets" {
  type        = list(any)
  description = "Promo CloudFront IP Sets for lower envs"
}
