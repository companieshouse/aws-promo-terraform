
# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  promo_proxy_ec2_data = data.vault_generic_secret.promo_proxy_ec2_data.data

  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  logs_kms_key_id        = local.security_kms_keys_data["cloudtrail-kms-key-arn"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]
  elb_access_logs_prefix      = "elb-access-logs"

  #For each log map passed, add an extra kv for the log group name
  fe_cw_logs = { for log, map in var.fe_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-fe-${log}" }) }

  fe_log_groups = compact([for log, map in local.fe_cw_logs : lookup(map, "log_group_name", "")])

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}