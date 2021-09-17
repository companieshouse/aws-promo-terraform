data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_cert_name
}