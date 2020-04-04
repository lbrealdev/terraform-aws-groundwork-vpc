# ---------------------------------------------------------------------------------------------------------------------
# THESE TEMPLATES REQUIRE TERRAFORM VERSION 0.12 AND ABOVE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.12"
}

locals {
  workspace = terraform.workspace

  tags = {
    Description = "Managed by Terraform"
    Environment = local.workspace
  }
}

resource "aws_vpc" "main" {
  count = var.create_vpc && var.cidr_block != null ? 1 : 0

  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    local.tags,
    {
      Name = "vpc-${local.workspace}-basic"
    }
  )
}

resource "aws_vpc_dhcp_options" "main" {
  count = var.create_vpc && var.domain_name == var.domain_name_servers != "" ? 1 : 0

  domain_name         = var.domain_name
  domain_name_servers = var.domain_name_servers

  tags = merge(
    local.tags,
    {
      Name = "dhcp-${local.workspace}"
    }
  )
}

resource "aws_vpc_dhcp_options_association" "main" {
  dhcp_options_id = aws_vpc_dhcp_options.main[0].id
  vpc_id          = aws_vpc.main[0].id
}

data "aws_availability_zones" "main" {
  state = "available"
}

resource "aws_subnet" "private" {
  count = var.create_vpc ? length(var.az) : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = cidrsubnet(aws_vpc.main[0].cidr_block, 8, count.index)
  availability_zone = concat(data.aws_availability_zones.main.names, [""])[count.index]

  tags = merge(
    local.tags,
    {
      Name ="subnet-${local.workspace}-private"
    }
  )
}

resource "aws_subnet" "public" {
  count = var.create_vpc ? length(var.az) : 0

  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = cidrsubnet(aws_vpc.main[0].cidr_block, 8, length(var.az) + count.index)
  availability_zone       = concat(data.aws_availability_zones.main.names, [""])[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "subnet-${local.workspace}-public"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main[0].id

  tags = merge(
    local.tags,
    {
      Name = "igw-${local.workspace}"
    }
  )
}

resource "aws_eip" "main" {
  count = var.create_vpc && length(aws_internet_gateway.main) > 0 ? length(aws_subnet.public) : 0

  vpc = true

  tags = merge(
    local.tags,
    {
      Name = "eip-${local.workspace}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count = var.create_vpc ? 3 : 0

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = element(aws_eip.main.*.id, count.index)
}

resource "aws_route_table" "main" {
  count = var.create_vpc && length(aws_internet_gateway.main) > 0 ? length(aws_nat_gateway.main) : 0

  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block     = var.rtb_cidr_block
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(
    local.tags,
    {
      Name = "rtb-${local.workspace}"
    }
  )
}

resource "aws_route_table_association" "main" {
  count = length(aws_route_table.main)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.main[count.index].id
}

resource "aws_route" "main" {
  route_table_id         = aws_vpc.main[0].main_route_table_id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = var.rtb_cidr_block
}