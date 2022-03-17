# terraform-aws-waf

This Terraform module deploys an AWS Web Application Firewall version 2 (WAFv2).

The following resources will be created:
- Web ACL with defined rule set (count or block)
- Optional Web Association with Application Load Balancer (ALB)
- Optional Web Association with Application CloudFront Distribution
- Optional CloudWatch logging configuration
- Optional CloudWatch log group

## Usage
Usage example with Application Load Balancer (ALB) and CloudFront Distribution.
```hcl
module "wafv2" {
  source   = "./wafv2"
  for_each = { for wfa in local.workspace.waf.wafv2 : wfa.name => wfa }

  environment                         = local.workspace.account_name
  wafv2_name                          = each.value.name
  wafv2_enable                        = each.value.enabled
  wafv2_scope                         = try(each.value.scope, "REGIONAL")
  wafv2_managed_count_rule_groups     = try(each.value.managed_count_rule_groups, [])
  wafv2_managed_block_rule_groups     = try(each.value.managed_block_rule_groups, [])
  wafv2_rate_limit_rule               = try(each.value.rate_limit_rule, 0)
  wafv2_cloudwatch_logging            = try(each.value.cloudwatch_logging, false)
  wafv2_cloudwatch_retention          = try(each.value.cloudwatch_retention, 3)
  wafv2_create_alb_association        = try(each.value.create_alb_association, false)
  wafv2_arn_alb_internet_facing       = try(each.value.arn_alb_internet_facing, [])
  wafv2_create_cloudfront_association = try(each.value.create_cloudfront_association, false)
  wafv2_arn_cloudfront_distribution   = try(each.value.arn_cloudfront_distribution, [])
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_wafv2_web_acl.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_association.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `any` | n/a | yes |
| <a name="input_wafv2_arn_alb_internet_facing"></a> [wafv2\_arn\_alb\_internet\_facing](#input\_wafv2\_arn\_alb\_internet\_facing) | ARN of the ALB to associate with the Web ACL | `any` | n/a | yes |
| <a name="input_wafv2_arn_cloudfront_distribution"></a> [wafv2\_arn\_cloudfront\_distribution](#input\_wafv2\_arn\_cloudfront\_distribution) | ARN of the CloudFront distribution to associate with the Web ACL | `any` | n/a | yes |
| <a name="input_wafv2_cloudwatch_logging"></a> [wafv2\_cloudwatch\_logging](#input\_wafv2\_cloudwatch\_logging) | Enable CloudWatch Logging | `bool` | `false` | no |
| <a name="input_wafv2_cloudwatch_retention"></a> [wafv2\_cloudwatch\_retention](#input\_wafv2\_cloudwatch\_retention) | CloudWatch Logging Retention in Days | `number` | `3` | no |
| <a name="input_wafv2_create_alb_association"></a> [wafv2\_create\_alb\_association](#input\_wafv2\_create\_alb\_association) | If associate Web ACL with the ALB | `bool` | `false` | no |
| <a name="input_wafv2_create_cloudfront_association"></a> [wafv2\_create\_cloudfront\_association](#input\_wafv2\_create\_cloudfront\_association) | If associate Web ACL with the CloudFront distribution | `bool` | `false` | no |
| <a name="input_wafv2_enable"></a> [wafv2\_enable](#input\_wafv2\_enable) | Deploys WAF V2 with Managed rule groups | `bool` | `false` | no |
| <a name="input_wafv2_managed_block_rule_groups"></a> [wafv2\_managed\_block\_rule\_groups](#input\_wafv2\_managed\_block\_rule\_groups) | List of WAF V2 managed rule groups, set to block | `list(string)` | `[]` | no |
| <a name="input_wafv2_managed_count_rule_groups"></a> [wafv2\_managed\_count\_rule\_groups](#input\_wafv2\_managed\_count\_rule\_groups) | List of WAF V2 managed rule groups, set to count | `list(string)` | `[]` | no |
| <a name="input_wafv2_name"></a> [wafv2\_name](#input\_wafv2\_name) | Name of Web Application Firewall. Usually the cluster name (ECS or EKS). In the case of EKS cluster will be needed too associate the ALB in the manifest of external-load-balance with the label alb.ingress.kubernetes.io/wafv2-acl-arn | `any` | n/a | yes |
| <a name="input_wafv2_rate_limit_rule"></a> [wafv2\_rate\_limit\_rule](#input\_wafv2\_rate\_limit\_rule) | The limit on requests per 5-minute period for a single originating IP address (leave 0 to disable) | `number` | `0` | no |
| <a name="input_wafv2_scope"></a> [wafv2\_scope](#input\_wafv2\_scope) | The scope of this Web ACL - Valid options: CLOUDFRONT, REGIONAL | `any` | n/a | yes |

## Outputs

No outputs.
