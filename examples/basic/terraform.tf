terraform {
  # see https://www.terraform.io/language/settings#specifying-provider-requirements
  required_providers {
    # see https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.2.0, < 4.3.0"

      # see https://www.terraform.io/language/modules/develop/providers#provider-aliases-within-modules
      configuration_aliases = [
        aws,
        aws.certificates
      ]
    }

    # see https://registry.terraform.io/providers/hashicorp/awscc/latest
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.13.0, < 0.14.0"
    }

    # see https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  # see https://www.terraform.io/language/settings#specifying-a-required-terraform-version
  required_version = ">= 1.1.6"
}
