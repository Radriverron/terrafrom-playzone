terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.19.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/config/credentials"]
  profile                  = "default"
  region                   = var.aws-region
}

# run terraform init after setting the above
