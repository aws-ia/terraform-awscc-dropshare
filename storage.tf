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
  length    = 3
  prefix    = random_string.suffix.result
  separator = "-"
}

# see https://www.terraform.io/language/values/locals
locals {
  # use randomly generated string for Bucket, if `var.bucket_name` was left empty
  bucket_name = length(var.bucket_name) != 0 ? var.bucket_name : "${random_pet.bucket_name.id}"
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  # public ACLs are required to allow sharing Bucket Objects via Dropshare
  block_public_acls = false

  # public Bucket Policies should not be blocked for this Bucket
  block_public_policy = false
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "bucket" {
  statement {
    sid    = "AllowCloudFrontOperationsOnBucketAndBucketObjects"
    effect = "Deny"

    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${awscc_cloudfront_cloudfront_origin_access_identity.main.id}"
      ]
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket.json
}

## see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "default"
    status = "Enabled"

    # see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/s3_bucket#nested-schema-for-lifecycle_configurationrulestransitions
    transition {
      days          = 30
      storage_class = var.bucket_storage_class
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.main.id

  # make object publicly readable
  acl = "public-read"

  # separate file name (and extension) from full path of the file
  key = basename("${path.module}/${var.bucket_index_file}")

  # generate an acceptable ETag for the file
  etag = filemd5("${path.module}/${var.bucket_index_file}")

  content_type = "text/html"
  source       = "${path.module}/${var.bucket_index_file}"
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "robotstxt" {
  bucket = aws_s3_bucket.main.id

  # make object publicly readable
  acl = "public-read"

  # separate file name (and extension) from full path of the file
  key = basename("${path.module}/${var.bucket_robotstxt_file}")

  # generate an acceptable ETag for the file
  etag = filemd5("${path.module}/${var.bucket_robotstxt_file}")

  content_type = "text/plain"
  source       = "${path.module}/${var.bucket_robotstxt_file}"
}
