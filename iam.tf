# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
resource "aws_iam_user" "main" {
  name = aws_s3_bucket.main.id
  path = var.iam_group_path
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
resource "aws_iam_access_key" "main" {
  user    = aws_iam_user.main.name
  pgp_key = "keybase:${var.keybase_user}"
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
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*"
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

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
resource "aws_iam_user_policy" "main" {
  policy = data.aws_iam_policy_document.main.json
  name   = aws_s3_bucket.main.id
  user   = aws_iam_user.main.name
}
