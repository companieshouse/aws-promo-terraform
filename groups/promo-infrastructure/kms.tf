module "kms" {
  for_each = merge(var.kms_customer_master_keys, local.kms_customer_master_keys)

  source = "git@github.com:companieshouse/terraform-modules//aws/kms?ref=tags/1.0.81"

  kms_key_alias           = "${var.account}/${var.region}/${each.key}"
  description             = lookup(each.value, "description", "${var.account}/${var.region}/${each.key}")
  deletion_window_in_days = lookup(each.value, "deletion_window_in_days", 30)
  enable_key_rotation     = lookup(each.value, "enable_key_rotation", true)
  is_enabled              = lookup(each.value, "is_enabled", true)

  kmsadmin_principals                = lookup(each.value, "kmsadmin_principals", null)
  kmsuser_principals                 = lookup(each.value, "kmsuser_principals", null)
  service_linked_role_principals     = lookup(each.value, "service_linked_role_principals", null)
  service_principal_names_non_region = lookup(each.value, "service_principal_names_non_region", null)

  tags = merge(
    local.default_tags,
    map(
      "Account", var.aws_account,
      "ServiceTeam", "Platform"
    )
  )
}