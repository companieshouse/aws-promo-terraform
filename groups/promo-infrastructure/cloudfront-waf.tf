provider "aws" {
  alias = "us-east"

  region = "us-east-1"
}


resource "aws_wafv2_ip_set" "ipset" {
  provider = aws.us-east

  name               = "promo-cf-ipset"
  description        = "Promo CloudFront IP Sets"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.promo_cf_ipsets
}

module "promo_cf_waf" {
  providers = {
    aws = aws.us-east
  }

  source  = "umotif-public/waf-webaclv2/aws"
  version = "~> 3.1.0"

  name_prefix            = "promo-cloudfront-waf"
  scope                  = "CLOUDFRONT"
  create_alb_association = false

  allow_default_action = false # set to allow if not specified

  visibility_config = {
    metric_name = "promo-cf-waf-main-metrics"
  }

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        excluded_rule = [
          "SizeRestrictions_QUERYSTRING",
          "SizeRestrictions_BODY",
          "GenericRFI_QUERYARGUMENTS"
        ]
      }
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet-rule-2"
      priority = "2"

      override_action = "count"

      visibility_config = {
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesPHPRuleSet-rule-3"
      priority = "3"

      override_action = "none"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesPHPRuleSet-metric"
        sampled_requests_enabled   = true
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "IpSetRule-4"
      priority = "4"

      action = "allow"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "IpSetRule-metric"
        sampled_requests_enabled   = false
      }

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.ipset.arn
      }
    }
  ]

  tags = {
    "Name" = "${var.application}-cf-waf"
    "Env"  = var.environment
  }
}
