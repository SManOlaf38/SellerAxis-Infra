resource "aws_s3_bucket" "photo_video_bucket" {
  bucket = "${var.photo_video_bucket_name}-${var.environment_name}"

  acl    = var.photo_video_bucket_acl
  tags = {
    Environment = var.environment_name
  }

  lifecycle {
    ignore_changes = ["cors_rule"]
  }

}

#s3 bucket policy
resource "aws_s3_bucket_policy" "s3_storage_photo_video" {
  bucket      = aws_s3_bucket.photo_video_bucket.id

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": [
            "s3:GetObject"
          ],
          "Resource": [
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
    allowed_origins = ["https://selleraxis.com", "http://localhost:3000", "http://localhost:8080"]
  }
}
