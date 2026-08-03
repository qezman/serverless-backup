variable "sns_topic_name" {
  description = "Name of the SNS topic for backup notifications"
  type        = string
}

variable "notification_email" {
  description = "Email address subscribed to backup alerts"
  type        = string
}

variable "slack_secret_name" {
  description = "Name of the Secrets Manager secret holding the Slack webhook URL"
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack incoming webhook URL"
  type        = string
  sensitive   = true
}

variable "vpc_cidr_block" {
  description = "CIDR block for the Project 3 VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the Project 3 VPC"
  type        = string
  default     = "project3-vpc"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "availability_zone" {
  description = "AZ to place the public subnet in"
  type        = string
  default     = "us-east-1a"
}