output "vpc_id" {
  value = aws_vpc.project3.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "ec2_sg_id" {
  description = "Security group ID for the EC2 backup instance"
  value       = aws_security_group.ec2_backup.id
}