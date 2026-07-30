resource "aws_iam_role" "ec2_backup" {
  name               = "${var.vpc_name}-ec2-backup-role"
  assume_role_policy = file("${path.module}/../../../iam/ec2-backup-role-trust-policy.json")
}

resource "aws_iam_role_policy" "ec2_backup" {
  name = "${var.vpc_name}-ec2-backup-permissions"
  role = aws_iam_role.ec2_backup.id
  policy = templatefile("${path.module}/../../../iam/ec2-backup-role-permissions-policy.json.tpl", {
    bucket_name = var.backups_bucket_name
  })
}

resource "aws_iam_instance_profile" "ec2_backup" {
  name = "${var.vpc_name}-ec2-backup-profile"
  role = aws_iam_role.ec2_backup.name
}