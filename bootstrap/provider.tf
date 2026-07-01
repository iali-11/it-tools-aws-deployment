terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.46.0"
    }
  }

  backend "s3" {
    bucket       = "it-tools-s3-bucket"
    key          = "bootstrap/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
  }
}
provider "aws" {
  region = "eu-west-2"
}