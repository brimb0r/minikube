resource "aws_sns_topic" "company-update-topic" {
  name = "${var.environment}-${var.aws_region}-company-update"
  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic" "aging-event-topic" {
  name = "${var.environment}-${var.aws_region}-aging-event"
  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic" "fi-day-end-notify-topic" {
  name = "${var.environment}-${var.aws_region}-fi-day-end-notify"
  tags = {
    Environment = var.environment
  }
}