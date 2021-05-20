locals {
  my_region = "eu-central-1"
  az_a = "${local.my_region}a"
  az_b = "${local.my_region}b"
  az_c = "${local.my_region}c"
  ip_bart = "84.84.60.15"
  ipv6_bart = "2a02:a460:bbf7:1:11e6:891c:6150:64a1" # static?
  cloud_linux_ami = "ami-02c29c0f4e8c685ca"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.15.3"

  backend "s3" {
    profile = "ginkio-infra"
    bucket = "ginkio-infra-tf"
    key = "key"
    region = "eu-central-1"
  }
}

provider "aws" {
  profile = "ginkio-infra"
  region = local.my_region
}
