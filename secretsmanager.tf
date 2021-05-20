resource "aws_secretsmanager_secret" "ginkio_infra_backup_user_secret" {
  name = "ginkio-infra-backup-user-secret"
}

resource "aws_secretsmanager_secret_version" "ginkio_infra_backup_user_secret" {
  secret_id = aws_secretsmanager_secret.ginkio_infra_backup_user_secret.id
  secret_string = aws_iam_access_key.ginkio_infra_backup_user_key.secret
}