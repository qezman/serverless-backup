variable "backups_bucket_name" {
  description = "Name of the S3 bucket storing encrypted database backups"
  type        = string
}

variable "tf_state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform's own state file"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function to invoke on new status markers"
  type        = string
}

variable "lambda_permission_dependency" {
  description = "The aws_lambda_permission resource, ensures it's created before the trigger"
  type        = any
}