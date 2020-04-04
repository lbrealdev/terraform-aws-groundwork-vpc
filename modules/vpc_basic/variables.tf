# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "create_vpc" {
  type    = bool
  default = true
}

variable "az" {
  type = any
  default = {
    a = 1
    b = 2
    c = 3
  }
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = " the suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file."
  type        = string
  default     = "eu-central-1.compute.internal"
}

variable "domain_name_servers" {
  description = ""
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "rtb_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}
