
resource "aws_ssm_parameter" "secret-segmented" {
  name = var.name
  type = "SecureString"
  // the default value of a secret should always be __NONE__; someone with admin privs should assign the value (typically in the UI)
  value  = var.value
  key_id = var.kms_key_id
  tier   = "Advanced"
  tags = {
    Environment = var.environment
  }
  lifecycle {
    prevent_destroy = true
  }
  overwrite = var.overwrite
}