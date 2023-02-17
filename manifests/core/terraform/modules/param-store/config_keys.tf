module "pgp-private-key" {
  source      = "./secret"
  name        = "/env.${var.environment}/pgp-private-key"
  environment = var.environment
  value       = var.pgp_private_key
  kms_key_id  = var.kms_key_id
}

module "pgp-private-key_part1" {
  source      = "./secret"
  name        = "/env.${var.environment}/pgp-private-key/1"
  environment = var.environment
  value       = var.pgp_private_key_part1
  kms_key_id  = var.kms_key_id
}

module "pgp-private-key_part2" {
  source      = "./secret"
  name        = "/env.${var.environment}/pgp-private-key/2"
  environment = var.environment
  value       = var.pgp_private_key_part2
  kms_key_id  = var.kms_key_id
}

module "pgp-private-key_part3" {
  source      = "./secret"
  name        = "/env.${var.environment}/pgp-private-key/3"
  environment = var.environment
  value       = var.pgp_private_key_part3
  kms_key_id  = var.kms_key_id
}

module "pgp-private-key_part4" {
  source      = "./secret"
  name        = "/env.${var.environment}/pgp-private-key/4"
  environment = var.environment
  value       = var.pgp_private_key_part4
  kms_key_id  = var.kms_key_id
}

module "pgp-private-key_part5" {
  source      = "./secret"
  name        = "/env.${var.environment}/pgp-private-key/5"
  environment = var.environment
  value       = var.pgp_private_key_part5
  kms_key_id  = var.kms_key_id
}