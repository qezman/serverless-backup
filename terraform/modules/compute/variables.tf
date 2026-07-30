variable "vpc_name" {
  description = "Base name, reused for consistent resource naming"
  type        = string
}

variable "public_key_path" {
  description = "Path to the local SSH public key file"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the dummy database box"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Public subnet ID the instance launches into"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID controlling access to the instance"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name, granting the instance s# access"
  type        = string
} 