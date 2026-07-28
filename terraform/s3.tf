# resource "aws_s3_bucket_policy" "backups" {
#   bucket = aws_s3_bucket_backups.id
#   policy = templatefile("${path.module}/../iams3-bucket-policy.json", {
#     bucket_name = var.bucket_name
#   })
# }