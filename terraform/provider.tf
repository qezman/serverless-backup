terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "serverless-backup-project-203637463799" # tf_state bucket name
    key          = "project3/terraform.tfstate"             # path inside the bucket
    region       = "us-east-1"
    use_lockfile = true
    profile      = "project3"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "project3"
}
