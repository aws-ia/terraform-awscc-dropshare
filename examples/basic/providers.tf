# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs
provider "awscc" {
  # configuration for this provider is handled through environment variables
  # see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs#environment-variables

  # TODO @ksatirli: add default_tags, once supported
  #  default_tags {
  #    tags = {
  #      terraform_managed = "true"
  #      terraform_module  = "aws-ia/terraform-module-awscc-dropshare"
  #    }
  #  }

  # TODO: @drewmullen verify IDs
  user_agent = [{
    product_name    = "terraform-awscc-dropshare"
    product_version = "0.1.0"
    comment         = "V1/AWS-D69B4015/<github repo id>"
  }]
}

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs
provider "aws" {
  # configuration for this provider is handled through environment variables
  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables

  # set this to the region you want to create the S3 Bucket in
  region = "us-west-1"

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags
  # also see https://learn.hashicorp.com/tutorials/terraform/aws-default-tags
  default_tags {
    tags = {
      terraform_managed = "true"
      terraform_module  = "operatehappy/terraform-module-awscc-dropshare"
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/awscc/latest/docs
provider "aws" {
  # ACM Certificates must be in `us-east-1` to be accessible to CloudFront
  alias  = "certificates"
  region = "us-east-1"

  # configuration for this provider is handled through environment variables
  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags
  # also see https://learn.hashicorp.com/tutorials/terraform/aws-default-tags
  default_tags {
    tags = {
      terraform_managed = "true"
      terraform_module  = "operatehappy/terraform-module-awscc-dropshare"
    }
  }
}

# see https://registry.terraform.io/providers/hashicorp/http/latest
provider "http" {}
