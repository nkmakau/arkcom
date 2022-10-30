## S3 Bucket outputs
output "vodasure_bucket_id" {
  description = "ID of the Vodasure S3 bucket"
  value       = aws_s3_bucket.vodasure-file-bucket.id
}

output "vodasure_bucket_arn" {
  description = "ID of the Vodasure S3 bucket"
  value       = aws_s3_bucket.vodasure-file-bucket.arn
}