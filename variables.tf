variable "bucket_index_file" {
  type        = string
  description = "Path to template file to use as Index for Bucket."
  default     = "templates/index.html"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 Bucket."
  default     = ""
}

# see https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html#aws-properties-route53-aliastarget-properties
variable "cloudfront_zone_id" {
  type        = string
  description = "ID of the CloudFront Route53 Hosted Zone."
  default     = "Z2FDTNDATAQYW2"
}

variable "comment" {
  type        = string
  description = "Comment to assign to relevant resources."
  default     = "Terraform-managed Resource for Dropshare Connection"
}

variable "iam_group_path" {
  type        = string
  description = "IAM Group Path for Service Accounts."
  default     = "/services/"
}

variable "keybase_user" {
  type        = string
  description = "KeyBase username for use in the `encrypted_secret` output attribute."
}

variable "routed53_zone_id" {
  type        = string
  description = "ID of the Route53 Hosted Zone."
}

variable "route53_record_subdomain" {
  type        = string
  description = "Subdomain Record to create in the Route53 Hosted Zone."
}
