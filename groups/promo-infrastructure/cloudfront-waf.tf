provider "aws" {
  alias = "us-east"

  region = "us-east-1"
}

resource "aws_wafv2_ip_set" "ipset" {
  provider = aws.us-east

  name               = "${var.application}-cf-ipset"
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
  version = "~> 5.1.2"

  name_prefix            = "${var.application}-cloudfront-waf"
  scope                  = "CLOUDFRONT"
  create_alb_association = false

  allow_default_action = var.environment == "live" ? true : false

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.application}-cf-waf-main-metrics"
    sampled_requests_enabled   = true
  }

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesCommonRuleSet-metric"
        sampled_requests_enabled   = true
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
      name     = "AWSManagedRulesAmazonIpReputationList-rule-2"
      priority = "2"

      override_action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAmazonIpReputationList-metric"
        sampled_requests_enabled   = true
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesAnonymousIpList-rule-3"
      priority = "3"

      override_action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAnonymousIpList-metric"
        sampled_requests_enabled   = true
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    },
    {
      name     = "IpSetRule-4"
      priority = "4"

      action = "allow"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "IpSetRule-metric"
        sampled_requests_enabled   = true
      }

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.ipset.arn
      }
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet-rule-5"
      priority = "5"

      override_action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesKnownBadInputsRuleSet-metric"
        sampled_requests_enabled   = true
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
  ]

  tags = {
    "Name" = "${var.application}-cloudfront-waf"
    "Env"  = var.environment
  }
}
