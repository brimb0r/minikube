output "file_arrival_queue_arn" {
  value = aws_sqs_queue.file_arrival_queue.arn
}

output "email_bounce_queue_arn" {
  value = aws_sqs_queue.email_bounce_queue.arn
}

output "scheduled_event_queue_arn" {
  value = aws_sqs_queue.scheduled_event_queue.arn
}

output "statements_queue_arn" {
  value = aws_sqs_queue.statements_queue.arn
}

output "corecard_queue_arn" {
  value = aws_sqs_queue.corecard_queue.arn
}