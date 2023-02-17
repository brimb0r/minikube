// Note: tagging these queues with the "Source" and "DeadLetter" queue terminology from this page:
//   https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html

locals {
  template_file              = "default_policy.json"
}

data "template_file" "core" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "core"
  }
}

resource "aws_sqs_queue" "core_queue" {
  name                      = "${var.environment}-${var.aws_region}-core"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.core_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.corecard.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "core_error_queue" {
  name                      = format("%s-%s-core-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}