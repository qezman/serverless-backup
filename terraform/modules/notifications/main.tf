# email subscribers get notified on any publish
resource "aws_sns_topic" "backup_notifications" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.backup_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Holds the Slack webhook URL
resource "aws_secretsmanager_secret" "slack_webhook" {
  name = var.slack_secret_name
}

resource "aws_secretsmanager_secret_version" "slack_webhook" {
  secret_id = aws_secretsmanager_secret.slack_webhook.id
  secret_string = var.slack_webhook_url
}
