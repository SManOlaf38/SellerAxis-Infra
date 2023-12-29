resource "aws_iam_role" "get_new_order_role" {
  name = "${var.environment_name}-${var.get_new_order_handle_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "retailer_getting_order_policy" {
  name = "${var.environment_name}-${var.retailer_getting_order_sqs_name}-policy"
  role = aws_iam_role.get_new_order_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:DeleteMessage",
        "sqs:GetQueueUrl",
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessageBatch",
        "sqs:SendMessageBatch",
        "sqs:ReceiveMessage",
        "sqs:SendMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibilityBatch",
        "sqs:ListQueues"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_sqs_queue" "failure_retailer_getting_order_sqs" {
  name = "${var.environment_name}-failure-${var.retailer_getting_order_sqs_name}"
  tags = {
    Environment = var.environment_name
  }
}

resource "aws_sqs_queue" "retailer_getting_order_sqs" {
  name = "${var.environment_name}-${var.retailer_getting_order_sqs_name}"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.failure_retailer_getting_order_sqs.arn,
    maxReceiveCount     = 3
  })
  tags = {
    Environment = var.environment_name
  }
}

data "archive_file" "get_new_order" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambdas/get_new_order_handle"
  output_path = "${path.module}/../../lambdas/get_new_order_handle.zip"
}

resource "aws_lambda_function" "get_new_order" {
  filename                       = "${path.module}/../../lambdas/get_new_order_handle.zip"
  function_name                  = "${var.environment_name}_${var.get_new_order_name}"
  role                           = aws_iam_role.get_new_order_role.arn
  handler                        = "main.lambda_handler"
  runtime                        = "python3.9"
  source_code_hash               = data.archive_file.get_new_order.output_base64sha256
  timeout                        = 60

  environment {
    variables = {
      API_HOST = var.api_host
      LAMBDA_SECRET = var.lambda_secret
    }
  }
}

# Cloudwatch Log
resource "aws_cloudwatch_log_group" "trigger_get_new_order" {
  name              = "/aws/lambda/${var.environment_name}_${var.get_new_order_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "trigger_get_new_order_policy" {
  name        = "${var.environment_name}-LoggingPolicy-${var.get_new_order_name}"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.get_new_order_role.name
  policy_arn = aws_iam_policy.trigger_get_new_order_policy.arn
}

resource "aws_cloudwatch_event_rule" "get_new_order" {
  name                = "${var.environment_name}_${var.trigger_get_new_order_name}"
  schedule_expression = "cron(0 5,11,17,23 * * ? *)"
  description         = "Get new order every 6 hours"
}

resource "aws_cloudwatch_event_target" "get_new_order_every_6_hours" {
    rule = aws_cloudwatch_event_rule.get_new_order.name
    target_id = "GetNewOrder"
    arn = aws_lambda_function.get_new_order.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_get_new_order" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.get_new_order.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.get_new_order.arn
}
