# retrieve caller's public IP address by querying remote service
# see `Notes` in `README.md` for security implications
# see https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http
data "http" "caller_public_ip_address" {
  # this value will be available in data.http.caller_public_ip_address.body
  url = var.iam_ip_address_retrieval_service

  request_headers = {
    Accept = "text/html"
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "main" {
  statement {
    sid    = "0"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = [
      awscc_s3_bucket.main.bucket_name,
      "${awscc_s3_bucket.main.bucket_name}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = [
        local.ip_address_constraint
      ]
    }

    principals {
      type = "AWS"
      identifiers = [
        awscc_cloudfront_cloudfront_origin_access_identity.main.id
      ]
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
