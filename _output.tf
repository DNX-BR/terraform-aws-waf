output "wafv2_arn" {
  value = try(aws_wafv2_web_acl.default[0].arn, "")
}
