data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_s3_bucket" "s3_system_history" {
  bucket = "${var.environment_name}-${var.system_history_bucket_name}"

  tags = {
    Environment = var.environment_name
  }
}

resource "aws_athena_workgroup" "system_history_athena_workgroup" {
  name = "${var.environment_name}_system_history_athena_workgroup"
  depends_on = [aws_s3_bucket.s3_system_history]
  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.s3_system_history.bucket}/query-id/"
    }
  }
}

resource "aws_athena_database" "system_history_athena_database" {
  name   = "${var.environment_name}_${var.system_history_database_name}"
  bucket = aws_s3_bucket.s3_system_history.id
}

resource "aws_glue_catalog_table" "system_history_table" {
  name          = "${var.environment_name}-${var.system_history_name}"
  database_name = aws_athena_database.system_history_athena_database.name

  partition_keys  {
    name = "year"
    type = "int"
  }
  partition_keys  {
    name = "month"
    type = "int"
  }
  partition_keys  {
    name = "day"
    type = "int"
  }
  partition_keys  {
    name = "author"
    type = "string"
  }
  partition_keys  {
    name = "request_uuid"
    type = "string"
  }

  storage_descriptor {
    columns {
        name = "request_data"
        type = "string"
    }
    columns {
        name = "response_data"
        type = "string"
    }
    columns {
        name = "process_data"
        type = "string"
    }
    columns {
        name = "run_time"
        type = "timestamp"
    }

    location      = "s3://${aws_s3_bucket.s3_system_history.bucket}/"
    input_format         = "org.apache.hadoop.mapred.TextInputFormat"
    output_format        = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed           = true

    ser_de_info {
      name = "JsonSerDe"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
      parameters = {
        "ignore.malformed.json" = "TRUE",
        "dots.in.keys"          = "FALSE",
        "case.insensitive"      = "TRUE",
        "mapping"               = "TRUE",
      }
    }
  }

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "classification"       = "json",
    "write.compression"    = "GZIP",
  }
}

resource "aws_iam_role" "trigger_system_history_role" {
  name = "${var.environment_name}-${var.system_history_name}-role"

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

resource "aws_iam_role_policy" "trigger_system_history_policy" {
  name = "${var.environment_name}-${var.system_history_name}-policy"
  role = aws_iam_role.trigger_system_history_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sqs:*",
      "Resource": [
        "${aws_sqs_queue.system_history_sqs.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.s3_system_history.arn}/*",
        "${aws_s3_bucket.s3_system_history.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "athena:*",
      "Resource": [
        "${aws_athena_workgroup.system_history_athena_workgroup.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "glue:*",
      "Resource": [
        "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
        "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${aws_athena_database.system_history_athena_database.name}",
        "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_athena_database.system_history_athena_database.name}/*"
      ]
    }
  ]
}
  EOF
}

resource "aws_sqs_queue" "failure_system_history_sqs" {
  name = "${var.environment_name}-${var.system_history_name}-failure-sqs"
  visibility_timeout_seconds = 60
  tags = {
    Environment = var.environment_name
  }
}

resource "aws_sqs_queue" "system_history_sqs" {
  name = "${var.environment_name}-${var.system_history_name}-sqs"
  visibility_timeout_seconds = 60
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.failure_system_history_sqs.arn,
    maxReceiveCount     = 4
  })
  tags = {
    Environment = var.environment_name
  }
}

data "archive_file" "trigger_system_history" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambdas/trigger_system_history"
  output_path = "${path.module}/../../lambdas/trigger_system_history.zip"
}

resource "aws_lambda_function" "trigger_system_history" {
  filename                       = "${path.module}/../../lambdas/trigger_system_history.zip"
  function_name                  = "${var.environment_name}-${var.system_history_name}-lambda"
  role                           = aws_iam_role.trigger_system_history_role.arn
  handler                        = "main.lambda_handler"
  runtime                        = "python3.9"
  source_code_hash               = data.archive_file.trigger_system_history.output_base64sha256
  timeout                        = 60

  environment {
    variables = {
      HISTORY_BUCKET = aws_s3_bucket.s3_system_history.bucket
      DB_NAME = aws_athena_database.system_history_athena_database.name
      TABLE_NAME = aws_glue_catalog_table.system_history_table.name
      WORK_GROUP = aws_athena_workgroup.system_history_athena_workgroup.name
    }
  }
}

resource "aws_lambda_event_source_mapping" "trigger_system_history_mapping" {
  event_source_arn = aws_sqs_queue.system_history_sqs.arn
  enabled          = true
  function_name    = aws_lambda_function.trigger_system_history.arn
  batch_size       = 10
  maximum_batching_window_in_seconds = 60
}

# Cloudwatch Log
resource "aws_cloudwatch_log_group" "trigger_system_history" {
  name              = "/aws/lambda/${var.environment_name}-${var.system_history_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "trigger_system_history_logging_policy" {
  name        = "${var.environment_name}-LoggingPolicy-${var.system_history_name}"
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
  role       = aws_iam_role.trigger_system_history_role.name
  policy_arn = aws_iam_policy.trigger_system_history_logging_policy.arn
}
