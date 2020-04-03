/*
provider "aws" {
  region  = "eu-central-1"
  version = "~> 2.0"
}

terraform {
  required_version = "~> 0.12"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2" {

  count = 3


  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"

  //  vpc_security_group_ids = ["sg-0765f5018637285ee"]

  security_groups = [
    "sg-0765f5018637285ee"
  ]
  subnet_id = "subnet-0ee84be84c8e322b9"

  key_name = "istio"
}*/
