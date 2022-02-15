# Dropshare Connection - AWS S3

> Terraform Module to create resources for a Dropshare Connection with AWS S3 and AWS CloudFront.

## Table of Contents

- [Dropshare Connection: AWS S3](#dropshare-connection-aws-s3)
  - [Table of Contents](#table-of-contents)
  - [Usage](#usage)
    - [Inputs](#inputs)
    - [Outputs](#outputs)
  - [Author Information](#author-information)
  - [License](#license)

## Usage

This section contains the input and output values of this module.

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_index\_file | Path to template file to use as Index for Bucket. | `string` | `"templates/index.html"` | no |
| bucket\_name | Name of the S3 Bucket. | `string` | `""` | no |
| bucket\_storage\_class | The class of storage used to store the object. | `string` | `"ONEZONE_IA"` | no |
| caller\_ip\_address | IP Address to constrain IAM Policy to. If left empty, this will be replaced with the caller's public IP address. | `string` | `""` | no |
| cloudfront\_comment | Comment to assign to CloudFront resources. | `string` | `"Terraform-managed Resource for Dropshare Connection"` | no |
| cloudfront\_minimum\_protocol\_version | The minimum version of the TLS protocol that you want CloudFront to use for HTTPS connections. | `string` | `"TLSv1.2_2021"` | no |
| cloudfront\_zone\_id | ID of the CloudFront Route53 Hosted Zone. | `string` | `"Z2FDTNDATAQYW2"` | no |
| iam\_group\_path | IAM Group Path for Service Accounts. | `string` | `"/services/"` | no |
| keybase\_user | KeyBase username for use in the `encrypted_secret` output attribute. | `string` | n/a | yes |
| lock\_policy\_to\_ip\_address | Toggle to enable constraining of IAM Policy to user-provided IP Address. | `bool` | `true` | no |
| route53\_record\_subdomain | Subdomain Record to create in the Route53 Hosted Zone. | `string` | n/a | yes |
| routed53\_zone\_id | ID of the Route53 Hosted Zone. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| access\_key\_id | IAM Access Key. |
| bucket\_id | S3 Bucket ARN. |
| bucket\_name | S3 Bucket Name. |
| domain\_alias | Domain Alias for CloudFront Distribution. |
| secret\_key | (encrypted) IAM Secret Key. |
| secret\_key\_decrypt\_command\_append | Appended part of Command to decrypt IAM Secret Key. |
| secret\_key\_decrypt\_command\_prepend | Prepended part of Command to decrypt IAM Secret Key. |
<!-- END_TF_DOCS -->

## Author Information

This repository is maintained by the contributors listed on [GitHub](https://github.com/operatehappy/terraform-module-awscc-dropshare/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
