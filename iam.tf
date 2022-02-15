# retrieve caller's public IP address by querying remote service
# see https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http
data "http" "caller_public_ip_address" {
  # TODO: check for AWS-owned service we can use for this.
  # this value will be available in data.http.caller_public_ip_address.body
  url = "https://icanhazip.com/"
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "main" {
  statement {
    sid    = "0"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      awscc_s3_bucket.main.bucket_name,
      "${awscc_s3_bucket.main.bucket_name}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [awscc_cloudfront_cloudfront_origin_access_identity.main.id]
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
resource "aws_iam_user" "main" {
  name = awscc_s3_bucket.main.bucket_name
  path = var.iam_group_path
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
resource "aws_iam_access_key" "main" {
  user    = aws_iam_user.main.name
  pgp_key = "keybase:${var.keybase_user}"
}
