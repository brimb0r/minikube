// Note: tagging these queues with the "Source" and "DeadLetter" queue terminology from this page:
//   https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html

locals {
  template_file              = "default_policy.json"
  file_arrival_template_file = "file_arrival_policy.json"
}

data "template_file" "corecard" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "corecard"
  }
}

resource "aws_sqs_queue" "corecard_queue" {
  name                      = "${var.environment}-${var.aws_region}-corecard"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.corecard_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.corecard.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "corecard_error_queue" {
  name                      = format("%s-%s-corecard-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "encompass" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "encompass"
  }
}

resource "aws_sqs_queue" "encompass_queue" {
  name                      = "${var.environment}-${var.aws_region}-encompass"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.encompass_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.encompass.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "encompass_error_queue" {
  name                      = format("%s-%s-encompass-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "file-arrival" {
  template = file("${path.module}/policy/${local.file_arrival_template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "file-arrival"
    s3_app_bucket_arn  = "arn:aws:s3:*:*:${var.app_file_storage}"
  }
}

resource "aws_sqs_queue" "file_arrival_queue" {
  name                      = "${var.environment}-${var.aws_region}-file-arrival"
  delay_seconds             = 5
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.file_arrival_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.file-arrival.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "file_arrival_error_queue" {
  name                      = format("%s-%s-file-arrival-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.app_file_storage
  queue {
    queue_arn = "arn:aws:sqs:us-east-1:000000000000:local-us-east-1-file-arrival"
    events    = ["s3:ObjectCreated:Put", "s3:ObjectCreated:Post", "s3:ObjectCreated:CompleteMultipartUpload"]
  }
}

data "template_file" "visa-in-clearing" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "visa-in-clearing"
  }
}

resource "aws_sqs_queue" "visa_in_clearing_queue" {
  name                      = "${var.environment}-${var.aws_region}-visa-in-clearing"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.visa_in_clearing_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.visa-in-clearing.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "visa_in_clearing_error_queue" {
  name                      = format("%s-%s-visa-in-clearing-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "mc-in-clearing" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "mc-in-clearing"
  }
}

resource "aws_sqs_queue" "mastercard_in_clearing_queue" {
  name                      = "${var.environment}-${var.aws_region}-mc-in-clearing"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.mastercard_in_clearing_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.mc-in-clearing.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "mastercard_in_clearing_error_queue" {
  name                      = format("%s-%s-mc-in-clearing-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "scheduled-event" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "scheduled-event"
  }
}

resource "aws_sqs_queue" "scheduled_event_queue" {
  name                      = "${var.environment}-${var.aws_region}-scheduled-event"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.scheduled_event_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.scheduled-event.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "scheduled_event_error_queue" {
  name                      = format("%s-%s-scheduled-event-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "wex" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "wex"
  }
}

resource "aws_sqs_queue" "wex_queue" {
  name                      = "${var.environment}-${var.aws_region}-wex"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.wex_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.wex.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "wex_error_queue" {
  name                      = format("%s-%s-wex-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "naf" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "naf"
  }
}

resource "aws_sqs_queue" "naf_queue" {
  name                      = "${var.environment}-${var.aws_region}-naf"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.naf_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.naf.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "naf_error_queue" {
  name                      = format("%s-%s-naf-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "statements" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "statements"
  }
}

resource "aws_sqs_queue" "statements_queue" {
  name                      = "${var.environment}-${var.aws_region}-statements"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.statements_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.statements.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "statements_error_queue" {
  name                      = format("%s-%s-statements-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "email" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "email"
  }
}

resource "aws_sqs_queue" "email_queue" {
  name                      = "${var.environment}-${var.aws_region}-email"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.email_error_queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.email.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "email_error_queue" {
  name                      = format("%s-%s-email-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "email-bounce" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "email-bounce"
  }
}

resource "aws_sqs_queue" "email_bounce_queue" {
  name                      = "${var.environment}-${var.aws_region}-email-bounce"
  delay_seconds             = 0
  max_message_size          = 65536
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  policy                    = data.template_file.email-bounce.rendered
}

data "template_file" "job-fnbo-encompass" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "fnbo-encompass"
  }
}

resource "aws_sqs_queue" "job-fnbo-encompass-queue" {
  name                      = "${var.environment}-${var.aws_region}-fnbo-encompass"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.job-fnbo-encompass-error-queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.encompass.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "job-fnbo-encompass-error-queue" {
  name                      = format("%s-%s-fnbo-encompass-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}

data "template_file" "job-fnbo-fi" {
  template = file("${path.module}/policy/${local.template_file}")
  vars = {
    aws_region         = var.aws_region
    aws_account_number = var.aws_account_number
    environment        = var.environment
    name               = "fnbo-fi"
  }
}

resource "aws_sqs_queue" "job-fnbo-fi-queue" {
  name                      = "${var.environment}-${var.aws_region}-fnbo-fi"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.job-fnbo-fi-error-queue.arn}\",\"maxReceiveCount\":2}"
  policy                    = data.template_file.encompass.rendered
  tags = {
    Environment = var.environment
    QueueType   = "Source"
  }
}

resource "aws_sqs_queue" "job-fnbo-fi-error-queue" {
  name                      = format("%s-%s-fnbo-fi-error", var.environment, var.aws_region)
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 0
  tags = {
    Environment = var.environment
    QueueType   = "DeadLetter"
  }
}