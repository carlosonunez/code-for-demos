variable "aws_vpc_cidr_block" {
  description = "The CIDR block to use for your VPC."
}

variable "aws_vpc_dns_domain" {
  description = "The DNS domain to which hosts within this VPC will be bound."
}

variable "aws_vpc_environment_name" {
  description = "The name of the environment to which hosts in this AWS account are bound."
}
