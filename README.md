# Dropshare Connection - AWS S3

> Terraform Module to create resources for a Dropshare Connection with AWS S3 and AWS CloudFront.

## Table of Contents

- [Dropshare Connection: AWS S3](#dropshare-connection-aws-s3)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Usage](#usage)
    - [Dropshare](#dropshare)
    - [Inputs](#inputs)
    - [Outputs](#outputs)
  - [Notes](#notes)
  - [Author Information](#author-information)
  - [License](#license)

## Overview

This [Terraform Module](https://learn.hashicorp.com/tutorials/terraform/module) creates the required resources to create an [S3 Connection](https://dropshare.zendesk.com/hc/en-us/articles/201139232-How-to-set-up-Amazon-S3-or-S3-API-compatible-connections) for [Dropshare](https://dropshare.app).

![Dropshare Workflow](images/dropshare.png "Dropshare Workflow")


```mermaid
  graph TD;
    dns_a[DNS Record, type A] --> tls;
    dns_aaaa[DNS Record, type AAAA] --> tls;
    tls[TLS Certificate] --> cloudfront;

    cloudfront[CloudFront Distribution];

    bucket[S3 Bucket] --> cloudfront;

    user[IAM User] --> bucket;
```

## Usage

This section contains the input and output values of this module as well as information on how to configure [Dropshare](https://dropshare.app/).

### Dropshare

To configure Dropshare, start from `basic` example available in [./examples/basic](https://github.com/ksatirli/terraform-awscc-dropshare/blob/main/examples/basic).

Modify the input values `bucket_name`, `keybase_user`, `routed53_zone_id` and `route53_record_subdomain` to reflect your infrastructure.

Next, carry out a [Terraform run](https://www.terraform.io/cli/run), executing the `terraform plan`, and `terraform apply`.

When the [apply](https://www.terraform.io/cli/run#applying) process finishes, Terraform will present the required [outputs](https://www.terraform.io/language/values/outputs) to configure Dropshare:

```shell
Outputs:

access_key_id              = "AKIAIOSFODNN7EXAMPLE"
bucket_name                = "aws-ia-dropshare"
domain_alias               = "aws-ia-dropshare.svcs.dev"
region                     = "us-west-1"
secret_key                 = "wcB...A=="
secret_key_decrypt_command = "terraform output -raw secret_key | base64 --decode | keybase pgp decrypt"
```

> Note that the `secret_key` output is the _encrypted_ value of the AWS IAM Secret Access Key. To decrypt it, run the decryption command presented in the `secret_key_decrypt_command` output.

Using the outputs, you can configure a Dropshare Connection for AWS S3:

![Dropshare Configuration](files/dropshare_configuration.png)

For additional examples, see the [/examples](https://github.com/aws-ia/terraform-awscc-dropshare/blob/main/examples/) directory.

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| keybase\_user | KeyBase username for use in the `encrypted_secret` output attribute. | `string` | n/a | yes |
| route53\_record\_subdomain | Subdomain Record to create in the Route53 Hosted Zone. | `string` | n/a | yes |
| routed53\_zone\_id | ID of the Route53 Hosted Zone. | `string` | n/a | yes |
| bucket\_index\_file | Path to template file to use as Index for Bucket. | `string` | `"files/index.html"` | no |
| bucket\_name | Name of the S3 Bucket. When left empty, a random name will be generated. | `string` | `""` | no |
| bucket\_robotstxt\_file | Path to template file to use as `robots.txt` for Bucket. | `string` | `"files/robots.txt"` | no |
| bucket\_storage\_class | The class of storage used to store the object. | `string` | `"ONEZONE_IA"` | no |
| caller\_ip\_address | IP Address to constrain IAM Policy to. If left empty, this will be replaced with the caller's public IP address. | `string` | `""` | no |
| cloudfront\_cache\_policy\_id | ID of AWS-managed Cache Policy. | `string` | `"658327ea-f89d-4fab-a63d-7e88639e58f6"` | no |
| cloudfront\_comment | Comment to assign to CloudFront resources. | `string` | `"Terraform-managed Resource for Dropshare Connection"` | no |
| cloudfront\_minimum\_protocol\_version | The minimum version of the TLS protocol that you want CloudFront to use for HTTPS connections. | `string` | `"TLSv1.2_2021"` | no |
| cloudfront\_origin\_request\_policy\_id | ID of AWS-managed Origin Request Policy. | `string` | `"59781a5b-3903-41f3-afcb-af62929ccde1"` | no |
| cloudfront\_response\_headers\_policy\_id | ID of AWS-managed Response Headers Policy. | `string` | `"67f7725c-6f97-4210-82d7-5512b31e9d03"` | no |
| cloudfront\_zone\_id | ID of the CloudFront Route53 Hosted Zone. | `string` | `"Z2FDTNDATAQYW2"` | no |
| create\_index\_file | Boolean Toggle to enable creation of Index File (`var.bucket_index_file`) in Bucket. | `bool` | `true` | no |
| create\_robotstxt\_file | Boolean Toggle to enable creation of Robots File (`var.bucket_robotstxt_file`) in Bucket. | `bool` | `true` | no |
| iam\_group\_path | IAM Group Path for Service Accounts. | `string` | `"/services/"` | no |
| iam\_ip\_address\_retrieval\_service | URL for (Public) IP Address Retrieval Service. | `string` | `"https://checkip.amazonaws.com/"` | no |
| lock\_policy\_to\_ip\_address | Toggle to enable constraining of IAM Policy to user-provided IP Address. | `bool` | `true` | no |

### Outputs

| Name | Description |
|------|-------------|
| access\_key\_id | IAM Access Key. |
| bucket\_id | S3 Bucket ARN. |
| bucket\_name | S3 Bucket Name. |
| domain\_alias | Domain Alias for CloudFront Distribution. |
| region | S3 Bucket Region. |
| secret\_key | (encrypted) IAM Secret Key. |
| secret\_key\_decrypt\_command\_append | Appended part of Command to decrypt IAM Secret Key. |
| secret\_key\_decrypt\_command\_prepend | Prepended part of Command to decrypt IAM Secret Key. |
<!-- END_TF_DOCS -->

## Notes

This section contains notes for this module.

### Public IP Retrieval Services

In [iam.tf](https://github.com/aws-ia/terraform-awscc-dropshare/blob/main/iam.tf), an [HTTP data source](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) is used to retrieve the caller's public IP address. This IP address is then used as a constraint for the module-created IAM policy.

Allowing a remote service to provide a string for constraining IAM Access to a specific source IP provides a limited, but non-zero security concern.

Should you wish to provide a different IP retrieval service, you can update the `iam_ip_address_retrieval_service` variable with the URL to a service you trust. See [variables.tf](https://github.com/aws-ia/terraform-awscc-dropshare/blob/main/variables.tf) and [iam.tf](https://github.com/aws-ia/terraform-awscc-dropshare/blob/main/iam.tf) for more information.

The [HTTP data source](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) may display a warning if the underlying retrieval services not expose a Content-Type that is compatible with the data source.

### Code Linting

This repository makes use of [GitHub Actions](https://github.com/aws-ia/terraform-awscc-dropshare/tree/main/.github/workflows) to provide support for a variety of linting tools.

To use [Snyk IaC](https://snyk.io/product/infrastructure-as-code-security/) scanning, a GitHub Actions Secret named `SNYK_TOKEN` must be [created](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository).

## Author Information

This repository is maintained by the contributors listed on [GitHub](https://github.com/aws-ia/terraform-awscc-dropshare/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
