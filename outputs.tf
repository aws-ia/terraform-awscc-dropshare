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

output "iam_secret_access_key" {
  description = "AWS IAM (encrypted) Secret Access Key."
  value       = aws_iam_access_key.main.encrypted_secret
}

output "decrypt_command_prepend" {
  description = "Prepended part of Command to decrypt IAM Secret Access Key."
  value       = "terraform output -raw"
}

output "decrypt_command_append" {
  description = "Appended part of Command to decrypt IAM Secret Access Key."
  value       = "| base64 --decode | keybase pgp decrypt"
}
