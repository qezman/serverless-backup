output "function_arn" {
  value = aws_lambda_function.notifier.arn
}

output "permission" {
  value = aws_lambda_permission.allow_s3
}