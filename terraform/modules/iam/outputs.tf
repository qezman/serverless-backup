output "instance_profile_name" {
  description = "Instance profile name, attached to the EC2 instance"
  value       = aws_iam_instance_profile.ec2_backup.name
}