variable "vpc_cidr_block" {
  description = "CIDR block for the Project 3 VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the Project 3 VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "AZ to place the public subnet in"
  type        = string
}