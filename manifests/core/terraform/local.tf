resource "aws_vpc" "mock_vpc" {
  cidr_block = "10.98.188.0/22"
}

module "s3" {
  source = "./modules/s3"
  aws_account_number = var.aws_account_number
  aws_region = var.aws_region
  environment = var.environment
}

module "sqs" {
  source = "./modules/sqs"
  app_file_storage = module.s3.primary_app_file_storage
  aws_account_number = var.aws_account_number
  aws_region = var.aws_region
  environment = var.environment
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
  aws_account_number = var.aws_account_number
  environment = var.environment
}

module "sns-topics" {
  source = "./modules/sns"
  aws_region = var.aws_region
  environment = var.environment
}