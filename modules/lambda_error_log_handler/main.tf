resource "aws_iam_role" "error_log_handler_role" {
  name = "${var.environment_name}-${var.lambda_name}-role"

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

resource "aws_iam_role_policy" "test-cloudwatch-lambda-policy" {
  name = "${var.environment_name}-${var.lambda_name}-policy"
  role = "${aws_iam_role.error_log_handler_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CopiedFromTemplateAWSLambdaVPCAccessExecutionRole1",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CopiedFromTemplateAWSLambdaVPCAccessExecutionRole2",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    },

    {
      "Sid": "CopiedFromTemplateAWSLambdaBasicExecutionRole1",
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "*"
    },
    {
      "Sid": "CopiedFromTemplateAWSLambdaBasicExecutionRole2",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CopiedFromTemplateAWSLambdaAMIExecutionRole",
      "Effect": "Allow",
      "Action": [
         "ec2:DescribeImages"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

data "archive_file" "error_log_handler" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambdas/error_log_handler"
  output_path = "${path.module}/../../lambdas/error_log_handler.zip"
}

resource "aws_lambda_function" "error_log_handler" {
  filename                       = "${path.module}/../../lambdas/error_log_handler.zip"
  function_name                  = "${var.environment_name}_${var.lambda_name}"
  role                           = aws_iam_role.error_log_handler_role.arn
  handler                        = "main.lambda_handler"
  runtime                        = "python3.9"
  source_code_hash = data.archive_file.error_log_handler.output_base64sha256

  environment {
    variables = {
      SLACK_WEBHOOK_HOST = var.slack_webhook_host
      ENV = var.environment_name
    }
  }
}

resource "aws_lambda_permission" "aws_lambda_permission_cloudwatch" {
  statement_id  = "${var.environment_name}-${var.lambda_name}-allow-cloudwatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.error_log_handler.arn}"
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn    = length(regexall(":\\*$", var.cloudwatch_log_arn)) == 1 ? var.cloudwatch_log_arn : "${var.cloudwatch_log_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "error_log_filter" {
  depends_on      = [aws_lambda_permission.aws_lambda_permission_cloudwatch]
  name            = "error_log_stream_filter"
  log_group_name  = var.cloudwatch_log_name
  filter_pattern  = "?ERROR ?Exception ?Error ?error ?exception ?Alert"
  destination_arn = aws_lambda_function.error_log_handler.arn
  distribution    = "ByLogStream"
}

# Cloudwatch Log
resource "aws_cloudwatch_log_group" "error_log_handler" {
  name              = "/aws/lambda/${var.environment_name}_${var.lambda_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "error_log_handler_logging_policy" {
  name        = "${var.environment_name}-LoggingPolicy-${var.lambda_name}"
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
  role       = aws_iam_role.error_log_handler_role.name
  policy_arn = aws_iam_policy.error_log_handler_logging_policy.arn
}

