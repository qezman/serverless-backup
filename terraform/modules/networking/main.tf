resource "aws_vpc" "project3" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.project3.id
    cidr_block = var.public_subnet_cidr_block
    availability_zone = var.availability_zone
      map_public_ip_on_launch   = true # EC2 instances here get a public IP automatically

  tags = {
    Name = "project3-public-subnet"
  }
}