resource "aws_cloudwatch_log_group" "selleraxis_cloudwatch_group" {
  name = "${var.cloudwatch_log_group_name}-${var.environment_name}"

  tags = {
    Environment = var.environment_name
  }

  retention_in_days = 30
}
