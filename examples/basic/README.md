# Example: Dropshare Connection - AWS S3

> Example code to create resources for a Dropshare Connection with AWS S3 and AWS CloudFront.

## Table of Contents

- [Example: Dropshare Connection - AWS S3](#example-dropshare-connection---aws-s3)
  - [Table of Contents](#table-of-contents)
  - [Usage](#usage)
    - [Inputs](#inputs)
    - [Outputs](#outputs)

## Usage

See [main.tf](https://github.com/aws-ia/terraform-awscc-dropshare/blob/main/examples/basic/main.tf) and [terraform.tfvars.sample](https://github.com/aws-ia/terraform-awscc-dropshare/blob/main/examples/basic/terraform.tfvars.sample) for an example of how to use this module with a _basic_ configuration.

This section contains the input and output values of this example.

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | Name of S3 Bucket to create. | `string` | n/a | yes |
| keybase\_user | Username of Keybase User to encrypt IAM Secret Key with. | `string` | n/a | yes |
| route53\_record\_subdomain | Subdomain to create DNS Record with. This value is used in combination with `var.route53_zone_id`. | `string` | n/a | yes |
| route53\_zone\_id | Route 53 Zone ID to create DNS Record in. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| access\_key\_id | Access Key ID Name for Dropshare Connection. |
| bucket\_name | S3 Bucket Name for Dropshare Connection. |
| domain\_alias | Domain Alias for Dropshare Connection. |
| region | Region for Dropshare Connection. |
| secret\_key | Encrypted Secret Key for Dropshare Connection. |
| secret\_key\_decrypt\_command | Command to decrypt IAM Secret Access Key for Dropshare Connection. |
<!-- END_TF_DOCS -->

## Notes

* For [aws_iam_access_key](https://www.terraform.io/docs/providers/aws/r/iam_access_key.html#encrypted_secret) Resources, the encrypted Access Key can be retrieved using the defined Terraform Outputs:

```sh
  terraform output -raw secret_key | \
  base64 --decode | \
  keybase pgp decrypt
```

Alternatively, a pre-rendered version of the command can be output using `terraform output secret_key_decrypt_command`.
