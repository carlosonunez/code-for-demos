variable "aws_vpc_cidr_block" {
  description = "The CIDR block to use for our VPC."
}

variable "aws_mgmt_subnet_cidr_block" {
  description = "The CIDR block for our management subnet. Must reside within the address space of the VPC's CIDR block."
}
