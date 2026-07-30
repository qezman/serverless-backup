{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPutBackupObjects",
      "Effect": "Allow",
      "Action": ["s3:PutObject"],
      "Resource": [
        "arn:aws:s3:::serverless-backup-project-560205084952/backups/*",
        "arn:aws:s3:::serverless-backup-project-560205084952/status/*"
      ]
    },
    {
      "Sid": "DenyInsecureTransport",
      "Effect": "Deny",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::serverless-backup-project-560205084952",
        "arn:aws:s3:::serverless-backup-project-560205084952/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
