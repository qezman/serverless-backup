# The bucket that will hold encrypted database backups.
resource "aws_s3_bucket" "backups" {
  bucket = "serverless-kazeem-db-backups-560205084952"
}

# Bucket to hold Terraform's own state file
resource "aws_s3_bucket" "tf_state" {
  bucket = "serverless-backup-project-560205084952"
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled" # keeps history of state files, lets recover from a bad apply
  }
}

# Keeps prior versions of objects when overwritten/deleted 
resource "aws_s3_bucket_versioning" "backups" {
  bucket = aws_s3_bucket.backups.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Forces AWS to encrypt every object at rest by default
resource "aws_s3_bucket_server_side_encryption_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Blocks all public access at the bucket level
resource "aws_s3_bucket_public_access_block" "backups" {
  bucket                  = aws_s3_bucket.backups.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Moves backup objects to Glacier after 30 days to cut storage cost,
# and deletes them entirely after 365 days
resource "aws_s3_bucket_lifecycle_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id

  rule {
    id     = "archive-old-backups"
    status = "Enabled"

    filter {
      prefix = "backups/"
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}

# email subscribers get notified on any publish
resource "aws_sns_topic" "backup_notifications" {
  name = "backup-notifications"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.backup_notifications.arn
  protocol  = "email"
  endpoint  = "contactqossim@gmail.com"
}


# Holds the Slack webhook URL
resource "aws_secretsmanager_secret" "slack_webhook" {
  name = "backup-notifier/slack-webhook"
}

resource "aws_secretsmanager_secret_version" "slack_webhook" {
  secret_id     = aws_secretsmanager_secret.slack_webhook.id
  secret_string = "https://hooks.slack.com/services/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"
}

module "networking" {
  source = "./modules/networking"
}