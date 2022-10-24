locals {
  wafv2_managed_count_rule_groups = [for i, v in var.wafv2_managed_count_rule_groups : { "name" : v, "type" : "managed" }]
  wafv2_managed_block_rule_groups = [for i, v in var.wafv2_managed_block_rule_groups : { "name" : v, "type" : "managed_block" }]
  
  wafv2_rate_limit_rule = var.wafv2_rate_limit_rule == 0 ? [] : [{
    "name" : "Block_Limit_Rate_Above_${var.wafv2_rate_limit_rule}"
    "type" : "rate"
    "value" : var.wafv2_rate_limit_rule
  }]
  wafv2_rules = concat(local.wafv2_rate_limit_rule, local.wafv2_managed_block_rule_groups, local.wafv2_managed_count_rule_groups)
}

resource "aws_wafv2_web_acl" "default" {
  count       = var.wafv2_enable ? 1 : 0
  name        = "waf-webacl-${var.wafv2_name}"
  description = "WAFv2 Web ACL for ${var.wafv2_name}"
  scope       = var.wafv2_scope

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = local.wafv2_rules

    content {
      name     = rule.value.name
      priority = rule.key

      dynamic "override_action" {
        for_each = rule.value.type == "managed" ? [1] : []
        content {
          count {}
        }
      }

      dynamic "override_action" {
        for_each = rule.value.type == "managed_block" ? [1] : []
        content {
          none {}
        }
      }

      dynamic "action" {
        for_each = rule.value.type == "rate" ? [1] : []
        content {
          block {}
        }
      }

      statement {
        dynamic "rate_based_statement" {
          for_each = rule.value.type == "rate" ? [1] : []
          content {
            limit              = rule.value.value
            aggregate_key_type = "IP"
          }
        }

        dynamic "managed_rule_group_statement" {
          for_each = rule.value.type == "managed" || rule.value.type == "managed_block" ? [1] : []
          content {
            name        = rule.value.name
            vendor_name = "AWS"
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.wafv2_cloudwatch_logging
        sampled_requests_enabled   = true
        metric_name                = "waf-${rule.value.name}"
      }
    }
  }

  tags = {
    Name = "waf-${var.wafv2_name}-web-application"
    Environment = var.environment
    Application = "WAF v2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.wafv2_cloudwatch_logging
    sampled_requests_enabled   = true
    metric_name                = "waf-general"
  }

  lifecycle {
    ignore_changes = [rule]
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  count        = var.wafv2_enable && var.wafv2_create_alb_association ? 1 : 0
  resource_arn = var.wafv2_arn_alb_internet_facing[0]
  web_acl_arn  = aws_wafv2_web_acl.default[0].arn
}

resource "aws_wafv2_web_acl_logging_configuration" "default" {
  count                   = var.wafv2_enable && var.wafv2_cloudwatch_logging ? 1 : 0
  log_destination_configs = [aws_cloudwatch_log_group.default[0].arn]
  resource_arn            = aws_wafv2_web_acl.default[0].arn
}

resource "aws_cloudwatch_log_group" "default" {
  count             = var.wafv2_enable && var.wafv2_cloudwatch_logging ? 1 : 0
  name              = "aws-waf-logs-${var.wafv2_name}"
  retention_in_days = var.wafv2_cloudwatch_retention

  tags = {
    Name = "aws-waf-logs-${var.wafv2_name}"
    Environment = var.environment
    Application = "WAF v2"
  }
}
