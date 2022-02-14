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

To decrypt the Secret Access Key (part of the `dropshare_secret_key_decrypt_command` output), you will need to have access to Keybase.

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
