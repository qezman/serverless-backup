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

# Zips the Python source into a deployable package.
data "archive_file" "notifier_zip" {
  type = "zip"
  source_dir = "${path.module}/../../lambda_src"
  output_path = "${path.module}/../../notifier.zip"
}

resource "aws_lambda_function" "notifier" {
  function_name = "backup-notifier"
  role = aws_iam_role.notifier.arn
  handler = "notifier.handler"
  runtime = "python3.12" 
  filename         = data.archive_file.notifier_zip.output_path
  source_code_hash = data.archive_file.notifier_zip.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
      SLACK_SECRET_ARN = var.slack_secret_arn
    }
  }
}

# Grants S3 permission to invoke this specific Lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notifier.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.backups_bucket_arn
}