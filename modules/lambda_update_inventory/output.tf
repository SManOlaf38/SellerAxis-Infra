output "lambda_function_arn" {
  value = aws_lambda_function.update_inventory_handler.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.update_inventory_handler.function_name
}
