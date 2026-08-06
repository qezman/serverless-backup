{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLambdaLogging",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${region}:${account_id}:log-group:/aws/lambda/backup-notifier:*"
    },
    {
      "Sid": "AllowReadStatusMarker",
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::${bucket_name}/status/*"
    },
    {
      "Sid": "AllowReadSlackWebhookSecret",
      "Effect": "Allow",
      "Action": ["secretsmanager:GetSecretValue"],
      "Resource": "arn:aws:secretsmanager:${region}:${account_id}:secret:backup-notifier/slack-webhook-*"
    },
    {
      "Sid": "AllowPublishToBackupTopic",
      "Effect": "Allow",
      "Action": ["sns:Publish"],
      "Resource": "arn:aws:sns:${region}:${account_id}:backup-notifications"
    }
  ]
}
