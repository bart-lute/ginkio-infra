resource "aws_backup_vault" "ginkio_infra_backup_vault" {
  name = "ginkio-infra-vault"
}

resource "aws_backup_plan" "ginkio_infra_backup_plan" {
  name = "ginkio-infra-plan"
  rule {
    rule_name = "daily"
    target_vault_name = aws_backup_vault.ginkio_infra_backup_vault.name
    schedule = "cron(0 5 ? * * *)"
    start_window = 480
    completion_window = 10080
    lifecycle {
      delete_after = 35
    }
  }
  rule {
    rule_name = "weekly"
    target_vault_name = aws_backup_vault.ginkio_infra_backup_vault.name
    schedule = "cron(0 5 ? * 7 *)"
    start_window = 480
    completion_window = 10080
    lifecycle {
      delete_after = 90
    }
  }
  rule {
    rule_name = "monthly"
    target_vault_name = aws_backup_vault.ginkio_infra_backup_vault.name
    schedule = "cron(0 5 1 * ? *)"
    start_window = 480
    completion_window = 10080
    lifecycle {
      cold_storage_after = 90
      delete_after = 1825
    }
  }
}

resource "aws_backup_selection" "ginkio_infra_plan_missioncritical" {
  iam_role_arn = "arn:aws:iam::762991194592:role/service-role/AWSBackupDefaultServiceRole"
  name = "mission-critical"
  plan_id = aws_backup_plan.ginkio_infra_backup_plan.id

  selection_tag {
    key = "BackupPlan"
    type = "STRINGEQUALS"
    value = "MissionCritical"
  }
}