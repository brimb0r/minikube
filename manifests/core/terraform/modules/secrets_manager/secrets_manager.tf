module "env_0003_ftps_password" {
  source = "./secret"
  secret_id = "0003-ftps-password"
  secret_value = "tg_avidia_pw"
}
module "env_0003_sftp_password" {
  source = "./secret"
  secret_id = "0003-sftp-password"
  secret_value = "tg_avidia_pw"
}
module "env_0001_sftp_password" {
  source = "./secret"
  secret_id = "0001-sftp-password"
  secret_value = "__NULL__"
}
module "datadog_app_key" {
  source = "./secret"
  secret_id = "datadog-app-key"
  secret_value = "fakeKey"
}
module "datadog_api_key" {
  source = "./secret"
  secret_id = "datadog-api-key"
  secret_value = "fakeKey"
}