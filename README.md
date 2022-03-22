# terraform-aws-waf

This Terraform module deploys an AWS Web Application Firewall version 2 (WAFv2).

The following resources will be created:
- Web ACL with a defined rule set (count or block)
- Optional Web Association with a list of Application Load Balancers (ALB)
- Optional CloudWatch logging configuration
- Optional CloudWatch log group

###### For association with CloudFront Distribution check the notes in the end of this page.

## Usage
Usage example with Application Load Balancer (ALB) or CloudFront Distribution.
```hcl
module "wafv2" {
  source   = "git::https://github.com/DNX-BR/terraform-aws-waf.git"
  for_each = { for wfa in local.workspace.waf.wafv2 : wfa.name => wfa }

  environment                         = local.workspace.account_name
  wafv2_name                          = try(each.value.name, "default")
  wafv2_enable                        = try(each.value.enabled, false)
  wafv2_scope                         = try(each.value.scope, "REGIONAL")
  wafv2_managed_count_rule_groups     = try(each.value.rules.managed_count_rule_groups, [])
  wafv2_managed_block_rule_groups     = try(each.value.rules.managed_block_rule_groups, [])
  wafv2_rate_limit_rule               = try(each.value.rules.rate_limit_rule, 0)
  wafv2_cloudwatch_logging            = try(each.value.cloudwatch.cloudwatch_logging, false)
  wafv2_cloudwatch_retention          = try(each.value.cloudwatch.cloudwatch_retention, 3)
  wafv2_create_alb_association        = try(each.value.alb_association.create_alb_association, false)
  wafv2_arn_alb_internet_facing       = try(each.value.alb_association.arn_alb_internet_facing, [])
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
| [aws_wafv2_web_acl.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `string` | n/a | yes |
| <a name="input_wafv2_name"></a> [wafv2\_name](#input\_wafv2\_name) | Name of Web Application Firewall. | `string` | n/a | yes |
| <a name="input_wafv2_enable"></a> [wafv2\_enable](#input\_wafv2\_enable) | Deploys WAF V2 with Managed rule groups | `bool` | `false` | yes |
| <a name="input_wafv2_scope"></a> [wafv2\_scope](#input\_wafv2\_scope) | The scope of this Web ACL. Set REGIONAL for ALB. Valid options: CLOUDFRONT, REGIONAL | `string` | n/a | yes |
| <a name="input_wafv2_managed_count_rule_groups"></a> [wafv2\_managed\_count\_rule\_groups](#input\_wafv2\_managed\_count\_rule\_groups) | List of WAF V2 managed rule groups, set to count | `list(string)` | `[]` | no |
| <a name="input_wafv2_managed_block_rule_groups"></a> [wafv2\_managed\_block\_rule\_groups](#input\_wafv2\_managed\_block\_rule\_groups) | List of WAF V2 managed rule groups, set to block | `list(string)` | `[]` | no |
| <a name="input_wafv2_rate_limit_rule"></a> [wafv2\_rate\_limit\_rule](#input\_wafv2\_rate\_limit\_rule) | The limit on requests per 5-minute period for a single originating IP address (leave 0 to disable) | `number` | `0` | no |
| <a name="input_wafv2_cloudwatch_logging"></a> [wafv2\_cloudwatch\_logging](#input\_wafv2\_cloudwatch\_logging) | Enable CloudWatch Logging | `bool` | `false` | no |
| <a name="input_wafv2_cloudwatch_retention"></a> [wafv2\_cloudwatch\_retention](#input\_wafv2\_cloudwatch\_retention) | CloudWatch Logging Retention in Days | `number` | `7` | no |
| <a name="input_wafv2_create_alb_association"></a> [wafv2\_create\_alb\_association](#input\_wafv2\_create\_alb\_association) | If associate Web ACL with the ALB | `bool` | `false` | no |
| <a name="input_wafv2_arn_alb_internet_facing"></a> [wafv2\_arn\_alb\_internet\_facing](#input\_wafv2\_arn\_alb\_internet\_facing) | List of ARN of the ALB to associate with the Web ACL | `string` | `[]` | required if `wafv2_create_alb_association` is set to `true` |

## Outputs

| Name | Type |
|------|------|
| wafv2_arn | output |

###### Remarks
In order to associate the Web ACL with CloudFront Distributions you must set the argument `web_acl_id` with the "Web ACL ARN" from this output in the resource [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#web_acl_id).
