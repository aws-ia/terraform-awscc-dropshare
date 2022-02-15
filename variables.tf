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
  description = "URL for (Public) IP Address Retrieval Service"
  default     = "https://icanhazip.com/"
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

locals {
  # use `var.caller_ip_address` if provided, else use caller's public IP address
  caller_ip_address = var.caller_ip_address != "" ? var.caller_ip_address : data.http.caller_public_ip_address.body

  # if `var.lock_policy_to_ip_address` is set to true, set to user-provided IP address
  ip_address_constraint = var.lock_policy_to_ip_address ? local.caller_ip_address : "0.0.0.0/0"
}
