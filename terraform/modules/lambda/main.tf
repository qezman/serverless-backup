resource "aws_iam_role" "notifier" {
    name = "${var.vpc_name}-lambda-notifier-role"
    assume_role_policy = file("${path.module}/../../../iam/lambda-notifier-role-trust-policy.json")
}

resource "aws_iam_role_policy" "notifier" {
    name = "${var.vpc_name}-lambda-notifier-permissions"
    role = aws_iam_role.notifier.id
      policy = templatefile("${path.module}/../../../iam/lambda-notifier-role-permissions-policy.json.tpl", {
        region = var.region
        account_id = var.account_id
        bucket_name = var.bucket_name
      })
}