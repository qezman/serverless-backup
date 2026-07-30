resource "aws_vpc" "project3" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.project3.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true # EC2 instances here get a public IP automatically

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_internet_gateway" "project3" {
  vpc_id = aws_vpc.project3.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.project3.id

  route {
    cidr_block = "0.0.0.0/0"                      # "any destination not inside this VPC"
    gateway_id = aws_internet_gateway.project3.id # ...send it out through the IGW
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ec2_backup" {
  name        = "${var.vpc_name}-ec2-sg"
  description = "Allow SSH from admin IP only, all outbound allowed"
  vpc_id      = aws_vpc.project3.id

  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_ip}/32"] // admin IP only
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # all protocols
    cidr_blocks = ["0.0.0.0/0"] # needed: S3 uploads, Slack webhook, apt/yum updates
  }

  tags = {
    Name = "${var.vpc_name}-ec2-sg"
  }
}
