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
  bucket = aws_s3_bucket.backups.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}