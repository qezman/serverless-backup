variable "vpc_name" {
  description = "Base name, reused for consistent resource naming"
  type        = string
}

variable "backups_bucket_name" {
  description = "Name of the S3 bucket the EC2 role is allowed to write to"
  type        = string
}