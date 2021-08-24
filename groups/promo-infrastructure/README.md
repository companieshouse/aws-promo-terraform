# aws-promo-terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_proxy_metrics"></a> [alb\_proxy\_metrics](#module\_alb\_proxy\_metrics) | git@github.com:companieshouse/terraform-modules//aws/alb-metrics?ref=tags/1.0.26 |  |
| <a name="module_promo_proxy_alb"></a> [promo\_proxy\_alb](#module\_promo\_proxy\_alb) | terraform-aws-modules/alb/aws | ~> 5.0 |
| <a name="module_promo_proxy_alb_security_group"></a> [promo\_proxy\_alb\_security\_group](#module\_promo\_proxy\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lb_target_group_attachment.ebilling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.epayments-test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.epayments_live](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_subnet_ids.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

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
| <a name="input_ebilling_server_ip"></a> [ebilling\_server\_ip](#input\_ebilling\_server\_ip) | Ebilling target server IP Address | `string` | `"172.16.200.179"` | no |
| <a name="input_ebilling_service_port"></a> [ebilling\_service\_port](#input\_ebilling\_service\_port) | Ebilling Target group backend port | `number` | `8085` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_epayments_live_server_ip"></a> [epayments\_live\_server\_ip](#input\_epayments\_live\_server\_ip) | Epayments live target server IP Address | `string` | `"172.16.200.172"` | no |
| <a name="input_epayments_service_port"></a> [epayments\_service\_port](#input\_epayments\_service\_port) | Epayments Target group backend port | `number` | `9000` | no |
| <a name="input_epayments_test_server_ip"></a> [epayments\_test\_server\_ip](#input\_epayments\_test\_server\_ip) | Epayments test target server IP Address | `string` | `"172.16.200.173"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Target group health check path | `string` | `"/"` | no |
| <a name="input_public_allow_cidr_blocks"></a> [public\_allow\_cidr\_blocks](#input\_public\_allow\_cidr\_blocks) | cidr block for allowing inbound users from internet | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->