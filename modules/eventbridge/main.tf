resource "aws_cloudwatch_event_rule" "lambda_event_rule" {
  name                = var.eventbridge_rule_name
  schedule_expression = var.schedule_expression
  tags = {
    Environment = var.environment_name
  }
}

resource "aws_cloudwatch_event_target" "lambda_event_target" {
  rule = aws_cloudwatch_event_rule.lambda_event_rule.name
  arn  = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_update_inventory_handler" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_event_rule.arn
}
