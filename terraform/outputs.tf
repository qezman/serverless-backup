output "backups_bucket_arn" {
  value = module.storage.backups_bucket_arn
}

output "sns_topic_arn" {
  value = module.notifications.sns_topic_arn
}