# aws-promo-proxy-terraform

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
| <a name="module_fe_asg"></a> [fe\_asg](#module\_fe\_asg) | git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling?ref=tags/1.0.36 |  |
| <a name="module_promo_proxy_external_alb"></a> [promo\_proxy\_external\_alb](#module\_promo\_proxy\_external\_alb) | terraform-aws-modules/alb/aws | ~> 5.0 |
| <a name="module_promo_proxy_external_alb_security_group"></a> [promo\_proxy\_external\_alb\_security\_group](#module\_promo\_proxy\_external\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 3.0 |
| <a name="module_promo_proxy_fe_asg_security_group"></a> [promo\_proxy\_fe\_asg\_security\_group](#module\_promo\_proxy\_fe\_asg\_security\_group) | terraform-aws-modules/security-group/aws | ~> 3.0 |
| <a name="module_promo_proxy_fe_profile"></a> [promo\_proxy\_fe\_profile](#module\_promo\_proxy\_fe\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.59 |  |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.promo_proxy_fe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_key_pair.promo_proxy_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.promo_proxy_fe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_key.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_kms_key.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_security_group.nagios_shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.promo_proxy_ec2_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_fe_ami_name"></a> [fe\_ami\_name](#input\_fe\_ami\_name) | Name of the AMI to use in the Auto Scaling configuration for frontend server(s) | `string` | `"promo-proxy-*"` | no |
| <a name="input_fe_cw_logs"></a> [fe\_cw\_logs](#input\_fe\_cw\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_fe_default_log_group_retention_in_days"></a> [fe\_default\_log\_group\_retention\_in\_days](#input\_fe\_default\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group if not specified for specific logs | `number` | `14` | no |
| <a name="input_fe_desired_capacity"></a> [fe\_desired\_capacity](#input\_fe\_desired\_capacity) | The desired capacity of ASG | `number` | n/a | yes |
| <a name="input_fe_health_check_path"></a> [fe\_health\_check\_path](#input\_fe\_health\_check\_path) | Target group health check path | `string` | `"/"` | no |
| <a name="input_fe_instance_size"></a> [fe\_instance\_size](#input\_fe\_instance\_size) | The size of the ec2 instances to build | `string` | n/a | yes |
| <a name="input_fe_max_size"></a> [fe\_max\_size](#input\_fe\_max\_size) | The max size of the ASG | `number` | n/a | yes |
| <a name="input_fe_min_size"></a> [fe\_min\_size](#input\_fe\_min\_size) | The min size of the ASG | `number` | n/a | yes |
| <a name="input_fe_service_port"></a> [fe\_service\_port](#input\_fe\_service\_port) | Target group backend port | `number` | `80` | no |
| <a name="input_public_allow_cidr_blocks"></a> [public\_allow\_cidr\_blocks](#input\_public\_allow\_cidr\_blocks) | cidr block for allowing inbound users from internet | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->