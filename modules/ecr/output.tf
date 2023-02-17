output "repository_url" {
  description = "The ECR Repository URL"
  value       = aws_ecr_repository.ecr.repository_url
}