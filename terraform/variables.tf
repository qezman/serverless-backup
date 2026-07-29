variable "vpc_cidr_block" {
    description = "CIDR block for the Project 3 VPC"
    type = string
    default = "10.20.0.0/16"
}

variable "vpc_name" {
    description = "Name tag for the Project 3 VPC"
    type = string
    default = "project3-vpc"
}

variable "public_subnet_cidr_block" {
    description = "CIDR block for the public subnet"
    type = string
    default = "10.20.1.0/24"
}

variable "availability_zone" {
    description = "AZ to place the public subnet in"
    type = string
    default = "us-west-1a"
}