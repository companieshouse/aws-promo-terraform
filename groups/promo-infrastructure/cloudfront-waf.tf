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


/*
module "waf" {
  providers = {
    aws = aws.us-east
  }

  source = "umotif-public/waf-webaclv2/aws"
  version = "~> 3.1.0"

  name_prefix = "test-waf-setup-cloudfront"
  scope = "CLOUDFRONT"
  create_alb_association = false
  ...
}
*/