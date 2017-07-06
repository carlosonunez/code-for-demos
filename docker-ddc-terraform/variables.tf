variable "aws_vpc_cidr_block" {
  description = "The VPC CIDR block to use for this environment."
}

variable "dns_zone_to_use" {
  description = "The public DNS zone into which deployed hosts will reside."
}

variable "environment_name" {
  description = "The name of the environment being deployed."
}

variable "environment_public_key" {
  description = "The public key to use for this environment. Ensure that its corresponding private key is stored somewhere where you won't lose it!"
}
