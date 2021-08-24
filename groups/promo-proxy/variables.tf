
# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "domain_cert_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "domain_name" {
  type        = string
  default     = "companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "public_allow_cidr_blocks" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "cidr block for allowing inbound users from internet"
}

# ------------------------------------------------------------------------------
# ALB variables
# ------------------------------------------------------------------------------
variable "ebilling_service_port" {
  type        = number
  default     = 8085
  description = "Ebilling Target group backend port"
}

variable "epayments_service_port" {
  type        = number
  default     = 9000
  description = "Epayments Target group backend port"
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path"
}

variable "ebilling_server_ip" {
  type        = string
  default     = "172.16.200.179"
  description = "Ebilling target server IP Address"
}

variable "epayments_live_server_ip" {
  type        = string
  default     = "172.16.200.172"
  description = "Epayments live target server IP Address"
}

variable "epayments_test_server_ip" {
  type        = string
  default     = "172.16.200.173"
  description = "Epayments test target server IP Address"
}

