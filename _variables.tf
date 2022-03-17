variable "wafv2_name" {
  description = "Name of Web Application Firewall. Usually the cluster name (ECS or EKS). In the case of EKS cluster will be needed too associate the ALB in the manifest of external-load-balance with the label alb.ingress.kubernetes.io/wafv2-acl-arn"
}

variable "wafv2_enable" {
  default     = false
  description = "Deploys WAF V2 with Managed rule groups"
}

variable "wafv2_scope" {
  description = "The scope of this Web ACL - Valid options: CLOUDFRONT, REGIONAL"
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
  default     = false
  description = "If associate Web ACL with the ALB"
}

variable "wafv2_arn_alb_internet_facing" {
  description = "ARN of the ALB to associate with the Web ACL"
}

variable "wafv2_create_cloudfront_association" {
  default     = false
  description = "If associate Web ACL with the CloudFront distribution"
}

variable "wafv2_arn_cloudfront_distribution" {
  description = "ARN of the CloudFront distribution to associate with the Web ACL"
}

variable "wafv2_cloudwatch_logging" {
  default     = false
  description = "Enable CloudWatch Logging"
}

variable "wafv2_cloudwatch_retention" {
  default     = 3
  description = "CloudWatch Logging Retention in Days"
}

variable "environment" {
  description = "Name of the environment"
}
