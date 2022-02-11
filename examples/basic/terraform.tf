terraform {
  # see https://www.terraform.io/language/settings#specifying-provider-requirements
  required_providers {

    # see https://registry.terraform.io/providers/hashicorp/awscc/latest
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.11.0"
    }
  }

  # see https://www.terraform.io/language/settings#specifying-a-required-terraform-version
  required_version = ">= 1.1.5"
}
