# terraform-groundwork-vpc

## Use this module

```
provider "aws" {
  region = "eu-central-1"
}

module "vpc" {
  source = "git::github.com/lbrealdev/terraform-aws-groundwork-vpc"

  cidr_block = "172.0.0.0/16"
}
```

```
Terraform module lifecicle

- Init terraform

terraform init
```
```
- Create a new workspace

terraform workspace list

terraform workspace new dev

- Check your new workspace

terraform workspace show
```
```
- Create a plan with plan file

terraform plan -out plan
```
```
- Apply infrastructure from plan

terraform apply plan
```
```
