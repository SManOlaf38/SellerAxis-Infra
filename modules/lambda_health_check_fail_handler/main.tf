resource "aws_iam_role" "health_check_fail_handler_role" {
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

resource "aws_iam_role_policy" "health_check_fail_handler_policy" {
  name = "${var.environment_name}-${var.lambda_name}-policy"
  role = aws_iam_role.health_check_fail_handler_role.id

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

resource "aws_sqs_queue" "failure_health_check_fail_handler_sqs" {
  name = "${var.environment_name}-failure-${var.lambda_name}"
  tags = {
    Environment = var.environment_name
  }
}

resource "aws_sqs_queue" "health_check_fail_handler_sqs" {
  name = "${var.environment_name}-${var.lambda_name}"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.failure_health_check_fail_handler_sqs.arn,
    maxReceiveCount     = 3
  })
  tags = {
    Environment = var.environment_name
  }
}

data "archive_file" "health_check_fail_handler" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambdas/health_check_fail_handler"
  output_path = "${path.module}/../../lambdas/health_check_fail_handler.zip"
}

resource "aws_lambda_function" "health_check_fail_handler" {
  filename                       = "${path.module}/../../lambdas/health_check_fail_handler.zip"
  function_name                  = "${var.environment_name}_${var.lambda_name}"
  role                           = aws_iam_role.health_check_fail_handler_role.arn
  handler                        = "main.lambda_handler"
  runtime                        = "python3.9"
  source_code_hash = data.archive_file.health_check_fail_handler.output_base64sha256

  environment {
    variables = {
      SLACK_WEBHOOK_HOST = var.slack_webhook_host
      ENV = var.environment_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "health_check_fail_handler_mapping" {
  event_source_arn = aws_sqs_queue.health_check_fail_handler_sqs.arn
  enabled          = true
  function_name    = aws_lambda_function.health_check_fail_handler.arn
  batch_size       = 1
}

# Cloudwatch Log
resource "aws_cloudwatch_log_group" "health_check_fail_handler" {
  name              = "/aws/lambda/${var.environment_name}_${var.lambda_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "health_check_fail_handler_logging_policy" {
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
  role       = aws_iam_role.health_check_fail_handler_role.name
  policy_arn = aws_iam_policy.health_check_fail_handler_logging_policy.arn
}

# Metric alarm
resource "aws_sns_topic" "health_check_fail_topic" {
  name = "${var.environment_name}-${var.sns_name}"
}

resource "aws_sqs_queue_policy" "health_check_fail_sqs_target" {
  queue_url = aws_sqs_queue.health_check_fail_handler_sqs.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.health_check_fail_handler_sqs.arn}"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.health_check_fail_topic.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sns_topic_subscription" "health_check_fail_sqs_target" {
  topic_arn = aws_sns_topic.health_check_fail_topic.arn
  protocol  = "sqs"
  raw_message_delivery = true
  endpoint  = aws_sqs_queue.health_check_fail_handler_sqs.arn
}

resource "aws_cloudwatch_metric_alarm" "health_check_metric" {
  alarm_name          = "${var.environment_name}-${var.alarm_metric_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  unit                = "Count"
  threshold           = 0
  alarm_description   = "Alarm when ECS health check fail"
  alarm_actions       = [aws_sns_topic.health_check_fail_topic.arn]
  dimensions = {
    TargetGroup  = var.target_group_arn_suffix
    LoadBalancer = var.lb_arn_suffix
  }
}
