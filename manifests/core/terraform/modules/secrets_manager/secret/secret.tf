resource "aws_secretsmanager_secret" "secret" {
  name = "${var.environment}-${var.secret_id}"
}
resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = "{\"${var.environment}-${var.secret_id}\":\"${var.secret_value}\"}"
}