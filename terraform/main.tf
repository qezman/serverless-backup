module "storage" {
  source               = "./modules/storage"
  backups_bucket_name  = var.backups_bucket_name
  tf_state_bucket_name = var.tf_state_bucket_name
}

module "notifications" {
  source             = "./modules/notifications"
  sns_topic_name     = var.sns_topic_name
  notification_email = var.notification_email
  slack_secret_name  = var.slack_secret_name
  slack_webhook_url  = var.slack_webhook_url
}

module "networking" {
  source                   = "./modules/networking"
  vpc_cidr_block           = var.vpc_cidr_block
  vpc_name                 = var.vpc_name
  public_subnet_cidr_block = var.public_subnet_cidr_block
  availability_zone        = var.availability_zone
  admin_ip                 = var.admin_ip
}