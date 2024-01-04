resource "aws_iam_role" "trigger_crud_product_quickbook_online_role" {
  name = "${var.environment_name}-${var.trigger_crud_product_quickbook_online_name}-role"

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

resource "aws_iam_role_policy" "trigger_crud_product_quickbook_online_policy" {
  name = "${var.environment_name}-${var.trigger_crud_product_quickbook_online_name}-policy"
  role = aws_iam_role.trigger_crud_product_quickbook_online_role.id

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

resource "aws_sqs_queue" "failure_crud_product_sqs" {
  name = "${var.environment_name}-failure-${var.crud_product_sqs_name}"
  tags = {
    Environment = var.environment_name
  }
}

resource "aws_sqs_queue" "crud_product_sqs" {
  name = "${var.environment_name}-${var.crud_product_sqs_name}"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.failure_crud_product_sqs.arn,
    maxReceiveCount     = 3
  })
  tags = {
    Environment = var.environment_name
  }
}

data "archive_file" "trigger_crud_product_quickbook_online" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambdas/trigger_crud_product_quickbook_online"
  output_path = "${path.module}/../../lambdas/trigger_crud_product_quickbook_online.zip"
}

resource "aws_lambda_function" "trigger_crud_product_quickbook_online" {
  filename                       = "${path.module}/../../lambdas/trigger_crud_product_quickbook_online.zip"
  function_name                  = "${var.environment_name}_${var.trigger_crud_product_quickbook_online_name}"
  role                           = aws_iam_role.trigger_crud_product_quickbook_online_role.arn
  handler                        = "main.lambda_handler"
  runtime                        = "python3.9"
  source_code_hash               = data.archive_file.trigger_crud_product_quickbook_online.output_base64sha256
  timeout                        = 60

  environment {
    variables = {
      API_HOST = var.api_host
      LAMBDA_SECRET = var.lambda_secret
    }
  }
}

resource "aws_lambda_event_source_mapping" "trigger_crud_product_quickbook_online_mapping" {
  event_source_arn = aws_sqs_queue.crud_product_sqs.arn
  enabled          = true
  function_name    = aws_lambda_function.trigger_crud_product_quickbook_online.arn
  batch_size       = 1
}

# Cloudwatch Log
resource "aws_cloudwatch_log_group" "trigger_crud_product_quickbook_online" {
  name              = "/aws/lambda/${var.environment_name}_${var.trigger_crud_product_quickbook_online_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "trigger_crud_product_quickbook_online_logging_policy" {
  name        = "${var.environment_name}-LoggingPolicy-${var.trigger_crud_product_quickbook_online_name}"
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
  role       = aws_iam_role.trigger_crud_product_quickbook_online_role.name
  policy_arn = aws_iam_policy.trigger_crud_product_quickbook_online_logging_policy.arn
}
