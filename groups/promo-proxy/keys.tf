# ------------------------------------------------------------------------------
# Promo Proxy Key Pair
# ------------------------------------------------------------------------------

resource "aws_key_pair" "promo_proxy_keypair" {
  key_name   = var.application
  public_key = local.promo_proxy_ec2_data["public-key"]
}