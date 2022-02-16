# see https://www.terraform.io/language/modules/syntax#calling-a-child-module
module "dropshare" {
  # see https://www.terraform.io/language/modules/sources#local-paths
  source = "../.."

  # CloudFront and ACM require resources to be created in a specific
  # region, so a secondary AWS Provider is passed as `aws.certificates`
  # see https://www.terraform.io/language/meta-arguments/module-providers
  providers = {
    aws              = aws
    aws.certificates = aws.certificates
  }

  bucket_name               = "aws-ia-dropshare-aws"
  keybase_user              = "operatehappy"
  lock_policy_to_ip_address = true
  caller_ip_address         = "127.0.0.1/0"
  routed53_zone_id          = "Z022183919I9SRBSJMSTV"
  route53_record_subdomain  = "aws-ia-dropshare-aws"
}

# see https://www.terraform.io/language/values/outputs
output "dropshare_bucket_name" {
  description = "S3 Bucket Name for Dropshare Connection."
  value       = module.dropshare.bucket_name
}

# see https://www.terraform.io/language/values/outputs
output "dropshare_access_key_id" {
  description = "Access Key ID Name for Dropshare Connection."
  value       = module.dropshare.access_key_id
}

# update the `value` attronite of the `dropshare_secret_key_decrypt_command`
# output if the identifier of the `dropshare_secret_key` output is changed
# see https://www.terraform.io/language/values/outputs
output "dropshare_secret_key" {
  description = "Encrypted Secret Key for Dropshare Connection."
  value       = module.dropshare.secret_key
}

# see https://www.terraform.io/language/values/outputs
output "dropshare_secret_key_decrypt_command" {
  description = "Command to decrypt IAM Secret Access Key for Dropshare Connection."
  value       = "${module.dropshare.secret_key_decrypt_command_prepend} dropshare_secret_key ${module.dropshare.secret_key_decrypt_command_append}"
}

# see https://www.terraform.io/language/values/outputs
output "dropshare_region" {
  description = "Region for Dropshare Connection."
  value       = module.dropshare.region
}
