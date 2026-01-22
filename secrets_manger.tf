resource "aws_secretsmanager_secret" "terraform_secret" {
  name = "terraform-secret"
}

resource "aws_secretsmanager_secret_version" "terraform_secret_value" {
  secret_id = aws_secretsmanager_secret.terraform_secret.id

  secret_string = jsonencode({
    username = "xxxxx"
    password = "xxxxxxxxx"
  })
}
