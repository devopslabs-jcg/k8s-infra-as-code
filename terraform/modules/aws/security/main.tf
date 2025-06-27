resource "aws_wafv2_web_acl" "main" {
  name  = "${var.project_name}-waf-acl"
  scope = "REGIONAL"
  default_action { allow {} }
  rule {
    name     = "AWS-Managed-CommonRuleSet"
    priority = 1
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    override_action { none {} }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-common-rules"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-main"
    sampled_requests_enabled   = true
  }
}
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}
