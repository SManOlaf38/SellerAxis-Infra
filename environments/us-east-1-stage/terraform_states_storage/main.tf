terraform {
  required_providers { aws = "~> 3.60" }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "s3_storage_state" {
  bucket = "${var.environment_name}-${var.bucket_s3_storage_state_name}"

  tags = {
    enviroment = var.environment_name
  }
}


resource "aws_s3_bucket_public_access_block" "s3_storage_state" {
  bucket                  = aws_s3_bucket.s3_storage_state.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3_storage_state" {
  bucket = aws_s3_bucket.s3_storage_state.id
  rule {
    object_ownership = "ObjectWriter"
  }
  depends_on = [aws_s3_bucket_public_access_block.s3_storage_state]
}


resource "aws_s3_bucket_acl" "s3_storage_state" {
    bucket = aws_s3_bucket.s3_storage_state.id
    acl    = "public-read"
    depends_on = [aws_s3_bucket_ownership_controls.s3_storage_state]
}

#s3 bucket policy
resource "aws_s3_bucket_policy" "s3_storage_state" {
  bucket = aws_s3_bucket.s3_storage_state.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : [
            "s3:PutObjectAcl",
            "s3:PutObject",
            "s3:GetObject"
          ],
          "Resource" : [
            "${aws_s3_bucket.s3_storage_state.arn}/*",
            "${aws_s3_bucket.s3_storage_state.arn}"
          ]
        }
      ]
    }
  )
  depends_on = [ aws_s3_bucket_public_access_block.s3_storage_state ]
}
