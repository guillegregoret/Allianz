resource "aws_secretsmanager_secret" "allianz" {
  name       = "allianz"
  recovery_window_in_days = 0
}
resource "aws_secretsmanager_secret_version" "terraform" {
  secret_id     = aws_secretsmanager_secret.allianz.id
  secret_string = jsonencode(var.secrets)

}