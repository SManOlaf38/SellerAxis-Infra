resource "aws_iam_role" "update_inventory_handler_role" {
  name = "${var.environment_name}-${var.update_inventory_handler_name}-role"

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

data "archive_file" "update_inventory_handler" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambdas/update_inventory_handler"
  output_path = "${path.module}/../../lambdas/update_inventory_handler.zip"
}

resource "aws_lambda_function" "update_inventory_handler" {
  filename      = "${path.module}/../../lambdas/update_inventory_handler.zip"
  function_name = "${var.environment_name}-${var.update_inventory_handler_name}"
  role          = aws_iam_role.update_inventory_handler_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = data.archive_file.update_inventory_handler.output_base64sha256
  environment {
    variables = {
      API_HOST = var.api_host
    }
  }
}

resource "aws_iam_policy" "update_inventory_handler_logging_policy" {
  name        = "${var.environment_name}-LoggingPolicy-${var.update_inventory_handler_name}"
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

# Cloudwatch Log
resource "aws_cloudwatch_log_group" "update_inventory_handler" {
  name              = "/aws/lambda/${var.environment_name}_${var.update_inventory_handler_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_log" {
  role       = aws_iam_role.update_inventory_handler_role.name
  policy_arn = aws_iam_policy.update_inventory_handler_logging_policy.arn
}
