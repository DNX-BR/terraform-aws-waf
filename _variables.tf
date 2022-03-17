variable "wafv2_name" {
  type        = string
  description = "Name of Web Application Firewall. Usually the cluster name (ECS or EKS). In the case of EKS cluster will be needed too associate the ALB in the manifest of external-load-balance with the label alb.ingress.kubernetes.io/wafv2-acl-arn"
}

variable "wafv2_enable" {
  type        = bool
  default     = false
  description = "Deploys WAF V2 with Managed rule groups"
}

variable "wafv2_scope" {
  type        = string
  description = "The scope of this Web ACL. Set REGIONAL for ALB. Valid options: CLOUDFRONT, REGIONAL"
}

variable "wafv2_managed_count_rule_groups" {
  type        = list(string)
  default     = []
  description = "List of WAF V2 managed rule groups, set to count"
}

variable "wafv2_managed_block_rule_groups" {
  type        = list(string)
  default     = []
  description = "List of WAF V2 managed rule groups, set to block"
}

variable "wafv2_rate_limit_rule" {
  type        = number
  default     = 0
  description = "The limit on requests per 5-minute period for a single originating IP address (leave 0 to disable)"
}

variable "wafv2_create_alb_association" {
  type        = bool
  default     = false
  description = "If associate Web ACL with the ALB"
}

variable "wafv2_arn_alb_internet_facing" {
  type        = list(string)
  default     = []
  description = "List of ARN of the ALB to associate with the Web ACL"
}

variable "wafv2_create_cloudfront_association" {
  type        = bool
  default     = false
  description = "If associate Web ACL with the CloudFront distribution"
}

variable "wafv2_arn_cloudfront_distribution" {
  type        = list(string)
  default     = []
  description = "List of ARN of the CloudFront distribution to associate with the Web ACL"
}

variable "wafv2_cloudwatch_logging" {
  type        = bool
  default     = false
  description = "Enable CloudWatch Logging"
}

variable "wafv2_cloudwatch_retention" {
  type        = number
  default     = 7
  description = "CloudWatch Logging Retention in Days"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
}
