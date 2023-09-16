terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "terraform-aws-infrastructure"

    workspaces {
      name = "terraform-aws-infrastructure"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}