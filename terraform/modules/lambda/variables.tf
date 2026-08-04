variable "vpc_name" {
  description = "Base name, reused for consistent resource naming"
  type        = string
}

variable "region" {
  description = "AWS region resources are deployed in"
  type        = string
  default = "us-east-1"
}

variable "account_id" {
  description = "AWS account ID, used to scope IAM resource ARNs"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket the Lambda function reads status markers from"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic Lambda publishes backup notifications to"
  type        = string
}

variable "slack_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the Slack webhook URL"
  type        = string
}