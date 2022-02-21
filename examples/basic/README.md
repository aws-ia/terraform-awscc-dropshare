# Example: Dropshare Connection - AWS S3

> Example code to create resources for a Dropshare Connection with AWS S3 and AWS CloudFront.

## Table of Contents

- [Example: Dropshare Connection - AWS S3](#example-dropshare-connection---aws-s3)
  - [Table of Contents](#table-of-contents)
  - [Usage](#usage)
    - [Inputs](#inputs)
    - [Outputs](#outputs)

## Usage

This section contains the input and output values of this module.

<!-- BEGIN_TF_DOCS -->
### Inputs

No inputs.

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
