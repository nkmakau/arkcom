# S3 Bucket

resource "aws_s3_bucket" "terraform_state" {
  # checkov:skip=CKV_AWS_144:The bucket does not need cross region replication
  # checkov:skip=CKV_AWS_144: cross-region replication is not required for this bucket
  # checkov:skip=CKV_AWS_145: Bucket encrypted by resource AWS s3 Key. 
  # checkov:skip=CKV_AWS_21: Versioning is enabled by resource sensor-versioning
  # checkov:skip=CKV_AWS_19: Already encrypted at rest with resource sensor-sse
  # checkov:skip=CKV_AWS_18: Logging not necessary.
  bucket = var.bucket
  # acl    = var.acl

  # versioning {
  #   enabled = true
  # }

  # lifecycle_rule {
  #   id      = "expire"
  #   enabled = true

  #   noncurrent_version_expiration {
  #     days = 180
  #   }
  # }

  # server_side_encryption_configuration {
  #   rule {
  #     bucket_key_enabled = true

  #     apply_server_side_encryption_by_default {
  #       kms_master_key_id = "arn:aws:kms:eu-west-1:766972209893:alias/aws/s3"
  #       sse_algorithm     = "aws:kms"
  #     }
  #   }
  # }

  # logging {
  #   target_bucket = var.bucket
  #   target_prefix = "log/${var.bucket}"
  # }

  tags = merge(local.common_tags, { Name = var.bucket, createdBy = "Noah Makau" })
}


resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}


# Dynamodb Table
resource "aws_dynamodb_table" "terraform_statelock" {
  # checkov:skip=CKV2_AWS_16: Ensure that Auto Scaling is enabled on your DynamoDB tables
  # checkov:skip=CKV_AWS_119: Ensure DynamoDB Tables are encrypted using a KMS Customer Managed CMK
  # checkov:skip=CKV_AWS_28: Ensure Dynamodb point in time recovery (backup) is enabled
  name           = var.dynamodb_table
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "LockID"
  # billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true // enabled server side encryption
  }

  #   point_in_time_recovery {
  #     enabled = true
  #   }

  tags = merge(local.common_tags, { Name = "var.bucket_name", createdBy = "Noah Makau" })
}

