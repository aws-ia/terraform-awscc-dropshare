# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
resource "aws_iam_user" "main" {
  name = aws_s3_bucket.main.bucket
  path = var.iam_group_path
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
resource "aws_iam_access_key" "main" {
  user    = aws_iam_user.main.name
  pgp_key = "keybase:${var.keybase_user}"
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# also see https://learn.hashicorp.com/tutorials/terraform/aws-iam-policy#refactor-your-policy
data "aws_iam_policy_document" "main" {
  statement {
    sid    = "0"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:ListObjects",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*"
    ]

    # see https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html#condition-keys-sourceip
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = [
        local.ip_address_constraint
      ]
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
resource "aws_iam_user_policy" "main" {
  policy      = data.aws_iam_policy_document.main.json
  name_prefix = aws_s3_bucket.main.id
  user        = aws_iam_user.main.name
}
