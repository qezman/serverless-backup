resource "aws_iam_role" "notifier" {
    name = "${var.vpc_name}-lambda-notifier-role"
    assume_role_policy = file("${path.module}/../../../iam/lambda-notifier-role-trust-policy.json")
}