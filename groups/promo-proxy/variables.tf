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

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "public_allow_cidr_blocks" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "cidr block for allowing inbound users from internet"
}

# ------------------------------------------------------------------------------
# Promo Proxy Frontend Variables - ALB 
# ------------------------------------------------------------------------------

variable "fe_service_port" {
  type        = number
  default     = 80
  description = "Target group backend port"
}

variable "fe_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path"
}

variable "fe_default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "fe_ami_name" {
  type        = string
  default     = "promo-proxy-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for frontend server(s)"
}

variable "fe_instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "fe_min_size" {
  type        = number
  description = "The min size of the ASG"
}

variable "fe_max_size" {
  type        = number
  description = "The max size of the ASG"
}

variable "fe_desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "fe_cw_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}
