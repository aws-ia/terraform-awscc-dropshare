terraform {
  # see https://www.terraform.io/language/settings#specifying-provider-requirements
  required_providers {
    # see https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 4.1.0"

      # see https://www.terraform.io/language/modules/develop/providers#provider-aliases-within-modules
      configuration_aliases = [
        aws,
        aws.certificates
      ]
    }

    # see https://registry.terraform.io/providers/hashicorp/awscc/latest
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.11.0, < 0.12.0"
    }

    # see https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  # see https://www.terraform.io/language/settings#specifying-a-required-terraform-version
  required_version = ">= 1.1.5"
}
