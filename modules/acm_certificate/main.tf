resource "aws_acm_certificate" "selleraxis_cert" {
  domain_name       = var.domain_name
  validation_method = var.validation_method

  tags = {
    Environment = var.environment_name
  }

  lifecycle {
    create_before_destroy = true
  }
}