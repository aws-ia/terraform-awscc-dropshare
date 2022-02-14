# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key
resource "aws_iam_access_key" "main" {
  user    = aws_iam_user.main.name
  pgp_key = "keybase:${var.keybase_user}"
}
