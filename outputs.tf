output "bucket_id" {
  description = "S3 Bucket ARN."
  value       = awscc_s3_bucket.main.arn
}

output "bucket_name" {
  description = "S3 Bucket Name."
  value       = awscc_s3_bucket.main.bucket_name
}

output "iam_access_key" {
  description = "AWS IAM Access Key."
  value       = aws_iam_access_key.main.id
}
