# ------------------------------------------------------------------------------
# Data
# ------------------------------------------------------------------------------
data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "security_s3" {
  path = "aws-accounts/security/s3"
}