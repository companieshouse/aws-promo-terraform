# aws-promo-proxy-terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 6.0 |
| <a name="provider_aws.acm_provider"></a> [aws.acm\_provider](#provider\_aws.acm\_provider) | >= 0.3, < 4.0 |
| <a name="provider_aws.us-east"></a> [aws.us-east](#provider\_aws.us-east) | >= 0.3, < 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront_logs_bucket"></a> [cloudfront\_logs\_bucket](#module\_cloudfront\_logs\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.2.1 |
| <a name="module_kms"></a> [kms](#module\_kms) | git@github.com:companieshouse/terraform-modules//aws/kms?ref=tags/1.0.293 |  |
| <a name="module_promo_cf_waf"></a> [promo\_cf\_waf](#module\_promo\_cf\_waf) | umotif-public/waf-webaclv2/aws | ~> 5.1.2 |
| <a name="module_s3_promo_web_hosting_bucket"></a> [s3\_promo\_web\_hosting\_bucket](#module\_s3\_promo\_web\_hosting\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.2.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_s3_bucket_policy.s3_promo_web_hosting_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_wafv2_ip_set.ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [vault_generic_secret.kms](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [vault_generic_secret.s3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [vault_generic_secret.security_s3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_domain_cert_name"></a> [domain\_cert\_name](#input\_domain\_cert\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"companieshouse.gov.uk"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_kms_customer_master_keys"></a> [kms\_customer\_master\_keys](#input\_kms\_customer\_master\_keys) | Map of KMS customer master keys and key policies to be created | `map(any)` | `{}` | no |
| <a name="input_promo_cf_ipsets"></a> [promo\_cf\_ipsets](#input\_promo\_cf\_ipsets) | Promo CloudFronti IP Sets for lower envs | `list(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
