output "backups_bucket_arn" {
  description = "ARN of the backups bucket, for IAM policies to reference"
  value       = aws_s3_bucket.backups.arn
}

output "backups_bucket_id" {
  description = "Name/ID of the backups bucket"
  value       = aws_s3_bucket.backups.id
}