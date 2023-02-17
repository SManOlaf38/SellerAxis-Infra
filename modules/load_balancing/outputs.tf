output "alb_arn" {
  description = "The ALB ARN"
  value       = aws_lb.selleraxis_lb.arn
}

output "aws_lb_target_group_arn" {
  description = "The ALB target group ARN"
  value       = aws_lb_target_group.selleraxis_lb_target_group.arn
}
