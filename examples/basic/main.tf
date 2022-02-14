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

  bucket_name              = "operatehappy-dropshare-aws"
  keybase_user             = "operatehappy"
  routed53_zone_id         = "Z022183919I9SRBSJMSTV"
  route53_record_subdomain = "operatehappy-dropshare-aws"
}
