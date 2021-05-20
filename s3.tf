resource "aws_s3_bucket" "ginkio_infra_backup" {
  bucket = "ginkio-infra-backup"
  acl = "private"

  tags = {
    Name = "ginkio-infra-backup"
  }
}

resource "aws_s3_bucket_public_access_block" "ginkio_infra_backup_block" {
  bucket = aws_s3_bucket.ginkio_infra_backup.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


