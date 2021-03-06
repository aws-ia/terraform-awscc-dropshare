# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs
provider "awscc" {
  # configuration for this provider is handled transparently
  # see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs#environment-variables

  # TODO @ksatirli: add default_tags, once supported
  #  default_tags {
  #    tags = {
  #      terraform_managed = "true"
  #      terraform_module  = "aws-ia/terraform-awscc-dropshare"
  #    }
  #  }

  user_agent = [{
    product_name    = "terraform-awscc-dropshare"
    product_version = "0.1.0"

    # the ID can be retrieved using `gh`: `gh api repos/aws-ia/terraform-awscc-dropshare | jq .id`
    # see https://github.com/aws-ia/standards-terraform/blob/main/content/faq/_index.en.md#what-is-the-user_agent
    # note: the above link is currently only accessible to members of the `aws-ia` GitHub Organization
    comment = "V1/AWS-D69B4015/459237564"
  }]
}

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs
provider "aws" {
  # configuration for this provider is handled transparently
  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication

  # set this to the region you want to create the S3 Bucket in
  region = "us-east-1"

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags
  # also see https://learn.hashicorp.com/tutorials/terraform/aws-default-tags
  default_tags {
    tags = {
      terraform_managed = "true"
      terraform_module  = "aws-ia/terraform-awscc-dropshare"
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs
provider "aws" {
  # ACM Certificates must be in `us-east-1` to be accessible to CloudFront
  alias  = "certificates"
  region = "us-east-1"

  # configuration for this provider is handled transparently and not hard-coded
  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags
  # also see https://learn.hashicorp.com/tutorials/terraform/aws-default-tags
  default_tags {
    tags = {
      terraform_managed = "true"
      terraform_module  = "aws-ia/terraform-awscc-dropshare"
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/http/latest
# selectively disabling tflint for the `http` provider as `version` is set in `terraform.tf`
# tflint-ignore: terraform_required_providers
provider "http" {}
