# Create a S3 Bucket for the Vodasure
resource "aws_s3_bucket" "vodasure-file-bucket" {
  # checkov:skip=CKV_AWS_144: cross-region replication is not required for this bucket
  # checkov:skip=CKV_AWS_145: Bucket encrypted by resource AWS s3 Key. 
  # checkov:skip=CKV_AWS_21: Versioning is enabled by resource sensor-versioning
  # checkov:skip=CKV_AWS_19: Already encrypted at rest with resource sensor-sse
  # checkov:skip=CKV_AWS_18: Logging not necessary.
  bucket        = var.bucket_name
  force_destroy = true
  tags          = merge(local.common_tags, { Name = "${var.bucket_name}", createdBy = "Noah Makau" })
}
resource "aws_s3_bucket_acl" "vodasure-acl" {
  bucket = aws_s3_bucket.vodasure-file-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "vodasure-versioning" {
  bucket = aws_s3_bucket.vodasure-file-bucket.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vodasure-sse" {
  bucket = aws_s3_bucket.vodasure-file-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

## public Access Block
resource "aws_s3_bucket_public_access_block" "vodasure" {
  bucket                  = aws_s3_bucket.vodasure-file-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

