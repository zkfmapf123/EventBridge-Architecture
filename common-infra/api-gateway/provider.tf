provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }

  cloud {
    hostname     = "app.terraform.io" ## Fixed
    organization = "leedonggyu-org"   ## Organization Name

    ## Default Workspace
    workspaces {
      name = "common-gateway"
    }
  }
}

data "tfe_outputs" "vpc" {
  organization = "leedonggyu-org"
  workspace    = "common-vpc"
}

output "vpc" {
  value = data.tfe_outputs.vpc.nonsensitive_values
}
