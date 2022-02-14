output "bucket_id" {
  description = "S3 Bucket ARN."
  value       = awscc_s3_bucket.main.arn
}

output "bucket_name" {
  description = "S3 Bucket Name."
  value       = awscc_s3_bucket.main.bucket_name
}

output "access_key_id" {
  description = "IAM Access Key."
  value       = aws_iam_access_key.main.id
}

output "secret_key" {
  description = "(encrypted) IAM Secret Key."
  value       = aws_iam_access_key.main.encrypted_secret
}

output "secret_key_decrypt_command_prepend" {
  description = "Prepended part of Command to decrypt IAM Secret Key."
  value       = "terraform output -raw"
}

output "secret_key_decrypt_command_append" {
  description = "Appended part of Command to decrypt IAM Secret Key."
  value       = "| base64 --decode | keybase pgp decrypt"
}

output "domain_alias" {
  description = "Domain Alias for CloudFront Distribution."
  value       = aws_acm_certificate.main.domain_name
}
