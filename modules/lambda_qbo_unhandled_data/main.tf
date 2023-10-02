resource "aws_iam_role" "qbo_unhandled_data_role" {
  name = "${var.environment_name}-${var.qbo_unhandled_data_handler_name}-role"

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

resource "aws_iam_role_policy" "qbo_unhandled_data_handler_policy" {
  name = "${var.environment_name}-${var.qbo_unhandled_data_handler_name}-policy"
  role = aws_iam_role.qbo_unhandled_data_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_sqs_queue" "qbo_unhandled_data_sqs" {
  name = "${var.environment_name}-${var.qbo_unhandled_data_sqs_name}"
  tags = {
    Environment = var.environment_name
  }
}

data "archive_file" "qbo_unhandled_data_handler" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambdas/qbo_unhandled_data_handler"
  output_path = "${path.module}/../../lambdas/qbo_unhandled_data_handler.zip"
}

resource "aws_lambda_function" "qbo_unhandled_data_handler" {
  filename                       = "${path.module}/../../lambdas/update_inventory_to_commercehub_handler.zip"
  function_name                  = "${var.environment_name}_${var.qbo_unhandled_data_handler_name}"
  role                           = aws_iam_role.qbo_unhandled_data_role.arn
  handler                        = "main.lambda_handler"
  runtime                        = "python3.9"
  source_code_hash = data.archive_file.qbo_unhandled_data_handler.output_base64sha256

  environment {
    variables = {
      API_HOST = var.api_host
      LAMBDA_SECRET = var.lambda_secret
    }
  }
}

resource "aws_lambda_event_source_mapping" "qbo_unhandled_data_handler_mapping" {
  event_source_arn = aws_sqs_queue.qbo_unhandled_data_sqs.arn
  enabled          = true
  function_name    = aws_lambda_function.qbo_unhandled_data_handler.arn
  batch_size       = 1
}

# Cloudwatch Log
resource "aws_cloudwatch_log_group" "qbo_unhandled_data_handler" {
  name              = "/aws/lambda/${var.environment_name}_${var.qbo_unhandled_data_handler_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "qbo_unhandled_data_logging_policy" {
  name        = "${var.environment_name}-LoggingPolicy-${var.qbo_unhandled_data_handler_name}"
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
  role       = aws_iam_role.qbo_unhandled_data_role.name
  policy_arn = aws_iam_policy.qbo_unhandled_data_logging_policy.arn
}
