resource "aws_iam_user" "ginkio_infra_backup_user" {
  name = "ginkio-infra-backup-user"

  tags = {
    Name = "ginkio-infra-backup-user"
  }
}

resource "aws_iam_access_key" "ginkio_infra_backup_user_key" {
  user = aws_iam_user.ginkio_infra_backup_user.name
}

resource "aws_iam_user_policy" "ginkio_infra_backup_user_policy" {
  name = "ginkio-infra-backup-user-policy"
  user = aws_iam_user.ginkio_infra_backup_user.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Terraform",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.ginkio_infra_backup.arn}",
                "${aws_s3_bucket.ginkio_infra_backup.arn}/*"
            ]
        }
    ]
}
EOF

}

