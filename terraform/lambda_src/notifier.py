import json
import secrets
import boto3
import urllib.request
import os

from botocore.retries import bucket

s3 = boto3.client("s3")
sns = boto3.client("sns")
secrets = boto3.client("secretsmanager")


def handler(event, context):
    # S3 triggers this with an event containing the bucket/key that changed
    record = event["Record"][0]
    bucket = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]

    # Read the status marker file that triggered this Lambda
    obj = s3.get_object(Bucket=bucket, Key=key)
    status_data = json.loads(obj["Body"].read())
    status = status_data.get("status", "unknown")
    timestamp = status_data.get("timestamp", "unknown")

    message = f"Backup {status} at {timestamp} (bucket: {bucket})"

    # Publish to SNS
    sns.publish(
        TopicArn=os.environ["SNS_TOPIC_ARN"],
        Subject=f"Backup {status}",
        Message=message,
    )

    # Fetch Slack webhook URL from Secrets Manager, post to Slack
    secret = secrets.get_secret_value(SecretId=os.environ["SLACK_SECRET_ARN"])
    webhook_url = secret["SecretString"]

    slack_payload = json.dumps({"text": message}).encode("utf-8")
    req = urllib.request.Request(
        webhook_url, data=slack_payload, headers={"Content-Type": "application/json"}
    )
    urllib.request.urlopen(req)

    return {"statusCode": 200, "body": "Notification sent"}
