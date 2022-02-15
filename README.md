# Dropshare Connection - AWS S3

> Terraform Module to create resources for a Dropshare Connection with AWS S3 and AWS CloudFront.

## Table of Contents

- [Dropshare Connection: AWS S3](#dropshare-connection-aws-s3)
  - [Table of Contents](#table-of-contents)
  - [Usage](#usage)
    - [Inputs](#inputs)
    - [Outputs](#outputs)
  - [Notes](#notes)
  - [Author Information](#author-information)
  - [License](#license)

## Usage

This section contains the input and output values of this module.

For examples, see the [/examples](https://github.com/aws-ia/terraform-module-awscc-dropshare/blob/main/examples/) directory.

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| keybase\_user | KeyBase username for use in the `encrypted_secret` output attribute. | `string` | n/a | yes |
| route53\_record\_subdomain | Subdomain Record to create in the Route53 Hosted Zone. | `string` | n/a | yes |
| routed53\_zone\_id | ID of the Route53 Hosted Zone. | `string` | n/a | yes |
| bucket\_index\_file | Path to template file to use as Index for Bucket. | `string` | `"templates/index.html"` | no |
| bucket\_name | Name of the S3 Bucket. | `string` | `""` | no |
| bucket\_storage\_class | The class of storage used to store the object. | `string` | `"ONEZONE_IA"` | no |
| caller\_ip\_address | IP Address to constrain IAM Policy to. If left empty, this will be replaced with the caller's public IP address. | `string` | `""` | no |
| cloudfront\_comment | Comment to assign to CloudFront resources. | `string` | `"Terraform-managed Resource for Dropshare Connection"` | no |
| cloudfront\_minimum\_protocol\_version | The minimum version of the TLS protocol that you want CloudFront to use for HTTPS connections. | `string` | `"TLSv1.2_2021"` | no |
| cloudfront\_zone\_id | ID of the CloudFront Route53 Hosted Zone. | `string` | `"Z2FDTNDATAQYW2"` | no |
| iam\_group\_path | IAM Group Path for Service Accounts. | `string` | `"/services/"` | no |
| iam\_ip\_address\_retrieval\_service | URL for (Public) IP Address Retrieval Service | `string` | `"https://icanhazip.com/"` | no |
| lock\_policy\_to\_ip\_address | Toggle to enable constraining of IAM Policy to user-provided IP Address. | `bool` | `true` | no |

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

## Notes

This section contains notes for this module.

### Public IP Retrieval Services

In [iam.tf](https://github.com/aws-ia/terraform-module-awscc-dropshare/blob/main/iam.tf), an [HTTP data source](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) is used to retrieve the caller's public IP address. This IP address is then used as a constraint for the module-created IAM policy.

Allowing a remote service to provide a string for constraining IAM Access to a specific source IP provides a limited, but non-zero security concern.

Should you wish to provide a different IP retrieval service, you can update the `iam_ip_address_retrieval_service` variable with the URL to a service you trust. See [variables.tf](https://github.com/aws-ia/terraform-module-awscc-dropshare/blob/main/variables.tf) and [iam.tf](https://github.com/aws-ia/terraform-module-awscc-dropshare/blob/main/iam.tf) for more information.

## Author Information

This repository is maintained by the contributors listed on [GitHub](https://github.com/operatehappy/terraform-module-awscc-dropshare/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
