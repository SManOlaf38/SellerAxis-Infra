resource "aws_s3_bucket" "photo_video_bucket" {
  bucket = "${var.photo_video_bucket_name}-${var.environment_name}"

  tags = {
    Environment = var.environment_name
  }

  lifecycle {
    ignore_changes = [cors_rule]
  }

}

#s3 bucket policy
resource "aws_s3_bucket_policy" "s3_storage_photo_video" {
  bucket = aws_s3_bucket.photo_video_bucket.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : [
            "s3:GetObject"
          ],
          "Resource" : [
            "${aws_s3_bucket.photo_video_bucket.arn}/*",
            "${aws_s3_bucket.photo_video_bucket.arn}"
          ]
        }
      ]
    }
  )
}

resource "aws_s3_bucket_cors_configuration" "plant_bucket" {
  bucket = aws_s3_bucket.photo_video_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["https://selleraxis.com", "https://seller-axis-web-app.vercel.app", "http://localhost:3000", "http://localhost:8080", "https://dev.selleraxis.com", "https://selleraxis.com"]
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  bucket = aws_s3_bucket.photo_video_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.photo_video_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership_controls,
    aws_s3_bucket_public_access_block.bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.photo_video_bucket.id
  acl    = "public-read"
}
