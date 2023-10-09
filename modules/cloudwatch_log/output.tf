output "name" {
  description = "The Cloudwatch Log Name"
  value       = aws_cloudwatch_log_group.selleraxis_cloudwatch_group.name
}

output "arn" {
  description = "The Cloudwatch Log ARN"
  value       = aws_cloudwatch_log_group.selleraxis_cloudwatch_group.arn
}
