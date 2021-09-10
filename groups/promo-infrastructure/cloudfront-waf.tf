provider "aws" {
  alias = "us-east"

  region = "us-east-1"
}


resource "aws_waf_ipset" "ipset" {
  name = "Promo CloudFront IP Set"

  dynamic "ip_set_descriptors" {
    for_each = var.promo_cf_ipsets
    iterator = ips
    content {
      type  = "IPV4"
      value = ips.value.ip
    }
  }
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