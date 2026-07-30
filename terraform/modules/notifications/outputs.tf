output "sns_topic_arn" {
  description = "ARN of the SNS topic, needed by Lambda's IAM policy"
  value       = aws_sns_topic.backup_notifications.arn
}

output "slack_secret_arn" {
  description = "ARN of the Secrets Manager secret needed by Lambda's IAM policy"
  value       = aws_secretsmanager_secret.slack_webhook.arn
}