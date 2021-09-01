# ------------------------------------------------------------------------------
# Promo Proxy Security Group and rules
# ------------------------------------------------------------------------------
module "promo_proxy_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-alb-001"
  description = "Security group for the ${var.application} proxies"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = var.public_allow_cidr_blocks
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
}

#--------------------------------------------
# ALB Promo
#--------------------------------------------
module "promo_proxy_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "alb-${var.application}-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = true

  security_groups = [module.promo_proxy_alb_security_group.this_security_group_id]
  subnets         = data.aws_subnet_ids.public.ids

  access_logs = {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      target_group_index = 0
    },
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      priority             = 1

      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        host_headers  = ["ebilling.${var.domain_name}"],
        path_patterns = ["/customer-portal/"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 2

      actions = [
        {
          type               = "forward"
          target_group_index = 1
        }
      ]
      conditions = [{
        host_headers  = ["epayments.${var.domain_name}"],
        path_patterns = ["/payments-framework/payments-live/*", "/payments-live/*"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 3

      actions = [
        {
          type               = "forward"
          target_group_index = 2
        }
      ]
      conditions = [{
        host_headers  = ["epayments.${var.domain_name}"],
        path_patterns = ["/payments-test/*"]
      }]
    }
  ]
  target_groups = [
    {
      name                 = "tg-promo-ebilling-01"
      backend_protocol     = "HTTP"
      backend_port         = var.ebilling_service_port
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.health_check_path
        port                = var.ebilling_service_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "${var.application}-ebilling"
      }
    },
    {
      name                 = "tg-promo-epayments-live-01"
      backend_protocol     = "HTTP"
      backend_port         = var.epayments_service_port
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.health_check_path
        port                = var.epayments_service_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "${var.application}-epayments-live"
      }
    },
    {
      name                 = "tg-promo-epayments-test-01"
      backend_protocol     = "HTTP"
      backend_port         = var.epayments_service_port
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.health_check_path
        port                = var.epayments_service_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "${var.application}-epayments-test"
      }
    }
  ]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-Web-Support"
    )
  )
}

#--------------------------------------------
# ALB CloudWatch Merics
#--------------------------------------------
module "alb_proxy_metrics" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-metrics?ref=tags/1.0.26"

  load_balancer_id = module.promo_proxy_alb.this_lb_id
  target_group_ids = module.promo_proxy_alb.target_group_arns

  depends_on = [module.promo_proxy_alb]
}

#--------------------------------------------
# ALB Target Group Attachments
#--------------------------------------------
resource "aws_lb_target_group_attachment" "ebilling" {
  target_group_arn  = coalesce([for group in module.promo_proxy_alb.target_group_arns : group if can(regex("ebilling", group))]...)
  target_id         = var.ebilling_server_ip
  port              = var.ebilling_service_port
  availability_zone = "all"

  depends_on = [
    module.promo_proxy_alb
  ]
}

resource "aws_lb_target_group_attachment" "epayments_live" {
  target_group_arn  = coalesce([for group in module.promo_proxy_alb.target_group_arns : group if can(regex("epayments-live", group))]...)
  target_id         = var.epayments_live_server_ip
  port              = var.epayments_service_port
  availability_zone = "all"

  depends_on = [
    module.promo_proxy_alb
  ]
}

resource "aws_lb_target_group_attachment" "epayments-test" {
  target_group_arn  = coalesce([for group in module.promo_proxy_alb.target_group_arns : group if can(regex("epayments-test", group))]...)
  target_id         = var.epayments_test_server_ip
  port              = var.epayments_service_port
  availability_zone = "all"

  depends_on = [
    module.promo_proxy_alb
  ]
}
