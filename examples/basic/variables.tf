variable "bucket_name" {
  type        = string
  description = "Name of S3 Bucket to create."
}

variable "keybase_user" {
  type        = string
  description = "Username of Keybase User to encrypt IAM Secret Key with."
}

variable "route53_zone_id" {
  type        = string
  description = "Route 53 Zone ID to create DNS Record in."
}
variable "route53_record_subdomain" {
  type        = string
  description = "Subdomain to create DNS Record with. This value is used in combination with `var.route53_zone_id`."
}
