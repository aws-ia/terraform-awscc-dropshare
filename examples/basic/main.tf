# see https://www.terraform.io/language/modules/syntax#calling-a-child-module
module "dropshare" {
  # the `source`  parameter of this example uses a local path to allow
  # for a better testing experience; for actual module usage, consider
  # replacing `../..` with `"aws-ia/dropshare/awscc"`
  # see https://www.terraform.io/language/modules/sources#local-paths
  source = "../.."

  # CloudFront and ACM require resources to be created in a specific
  # region, so a secondary AWS Provider is passed as `aws.certificates`
  # see https://www.terraform.io/language/meta-arguments/module-providers
  providers = {
    aws              = aws
    aws.certificates = aws.certificates
  }

  bucket_name               = var.bucket_name
  keybase_user              = var.keybase_user
  lock_policy_to_ip_address = true
  routed53_zone_id          = var.route53_zone_id
  route53_record_subdomain  = var.route53_record_subdomain
}
