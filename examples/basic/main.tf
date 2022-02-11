module "dropshare_aws" {
  source = "../.."

  providers = {
    aws = aws
    aws.certificates = aws.certificates
  }

  bucket_name              = "operatehappy-dropshare-aws"
  routed53_zone_id         = "Z022183919I9SRBSJMSTV"
  route53_record_subdomain = "operatehappy-dropshare-aws"
}
