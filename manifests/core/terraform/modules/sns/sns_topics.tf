resource "aws_sns_topic" "company-update-topic" {
  name = "${var.environment}-${var.aws_region}-update"
  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic" "aging-event-topic" {
  name = "${var.environment}-${var.aws_region}event"
  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic" "fi-day-end-notify-topic" {
  name = "${var.environment}-${var.aws_region}-notify"
  tags = {
    Environment = var.environment
  }
}