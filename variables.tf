variable "bucket_index_file" {
  type        = string
  description = "Path to template file to use as Index for Bucket."
  default     = "files/index.html"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 Bucket. When left empty, a random name will be generated."
  default     = ""
}

# see https://docs.aws.amazon.com/AmazonS3/latest/API/API_Destination.html#AmazonS3-Type-Destination-StorageClass
variable "bucket_storage_class" {
  type        = string
  description = "The class of storage used to store the object."
  default     = "ONEZONE_IA"

  validation {
    condition     = can(contains(["STANDARD", "REDUCED_REDUNDANCY", "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING"], var.bucket_storage_class))
    error_message = "`bucket_storage_class` must be one of \"STANDARD\", \"REDUCED_REDUNDANCY\", \"STANDARD_IA\", \"ONEZONE_IA\", or \"INTELLIGENT_TIERING\"."
  }
}

variable "cloudfront_minimum_protocol_version" {
  type        = string
  description = "The minimum version of the TLS protocol that you want CloudFront to use for HTTPS connections."
  default     = "TLSv1.2_2021"
}

# see https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html#aws-properties-route53-aliastarget-properties
variable "cloudfront_zone_id" {
  type        = string
  description = "ID of the CloudFront Route53 Hosted Zone."
  default     = "Z2FDTNDATAQYW2"
}

variable "cloudfront_comment" {
  type        = string
  description = "Comment to assign to CloudFront resources."
  default     = "Terraform-managed Resource for Dropshare Connection"
}

variable "iam_group_path" {
  type        = string
  description = "IAM Group Path for Service Accounts."
  default     = "/services/"
}

variable "iam_ip_address_retrieval_service" {
  type        = string
  description = "URL for (Public) IP Address Retrieval Service."
  default     = "https://checkip.amazonaws.com/"
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

variable "lock_policy_to_ip_address" {
  type        = bool
  description = "Toggle to enable constraining of IAM Policy to user-provided IP Address."
  default     = true
}

variable "caller_ip_address" {
  type        = string
  description = "IP Address to constrain IAM Policy to. If left empty, this will be replaced with the caller's public IP address."
  default     = ""
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}

# retrieve caller's public IP address by querying remote service
# see `Notes` in `README.md` for security implications
# see https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http
data "http" "caller_public_ip_address" {
  # this value will be available in data.http.caller_public_ip_address.body
  url = var.iam_ip_address_retrieval_service

  request_headers = {
    Accept = "text/plain"
  }
}

locals {
  # use `var.caller_ip_address` if provided, else use caller's public IP address
  caller_ip_address = var.caller_ip_address != "" ? var.caller_ip_address : tostring(split("\n", data.http.caller_public_ip_address.body)[0])

  # if `var.lock_policy_to_ip_address` is set to true, set to user-provided IP address
  ip_address_constraint = var.lock_policy_to_ip_address ? local.caller_ip_address : "0.0.0.0/0"
}
