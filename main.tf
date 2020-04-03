# ---------------------------------------------------------------------------------------------------------------------
# THESE TEMPLATES REQUIRE TERRAFORM VERSION 0.12 AND ABOVE
# ----------------------------------------------------------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "./modules/vpc_basic"

  cidr_block = "172.0.0.0/16"
}