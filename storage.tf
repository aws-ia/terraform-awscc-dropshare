# this string is used as part of the S3 Bucket Name, so we're omitting
# uppercase and special characters, resulting in an all-lowercase string
# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "suffix" {
  length  = 8
  lower   = true
  number  = true
  special = false
  upper   = false
}

# see https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet
resource "random_pet" "bucket_name" {
  length = 3
  prefix = random_string.suffix.result
}

# see https://www.terraform.io/language/values/locals
locals {
  # use randomly generated string for Bucket, if `var.bucket_name` was left empty
  bucket_name = length(var.bucket_name) != 0 ? var.bucket_name : random_pet.bucket_name.id
}

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/s3_bucket
resource "awscc_s3_bucket" "main" {
  bucket_name = local.bucket_name
}
