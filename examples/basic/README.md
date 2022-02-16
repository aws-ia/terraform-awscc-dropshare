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
| dropshare\_access\_key\_id | Access Key ID Name for Dropshare Connection. |
| dropshare\_bucket\_name | S3 Bucket Name for Dropshare Connection. |
| dropshare\_region | Domain Alias for Dropshare Connection. |
| dropshare\_secret\_key | Encrypted Secret Key for Dropshare Connection. |
| dropshare\_secret\_key\_decrypt\_command | Command to decrypt IAM Secret Access Key for Dropshare Connection. |
<!-- END_TF_DOCS -->

## Notes

* For [aws_iam_access_key](https://www.terraform.io/docs/providers/aws/r/iam_access_key.html#encrypted_secret) Resources, the encrypted Access Key can be retrieved using the defined Terraform Outputs:

```sh
  terraform output dropshare_secret_key | \
  base64 --decode | keybase pgp decrypt && echo
```

Alternatively, a pre-rendered version of the command can be output using `terraform output dropshare_secret_key_decrypt_command`.
