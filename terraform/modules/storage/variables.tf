variable "backups_bucket_name" {
  description = "Name of the S3 bucket storing encrypted database backups"
  type        = string
}

variable "tf_state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform's own state file"
  type        = string
}