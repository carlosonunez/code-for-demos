variable "subnet_name" {
  description = "The name to give our subnet."
}

variable "vpc_id" {
  description = "The ID of the VPC into which this subnet will be provisioned."
}

variable "cidr_block" {
  description = "The CIDR block to give this subnet (that resides in the address space of its parent VPC)."
}

variable "aws_environment" {
  description = "The environment this subnet belongs to."
}

variable "enable_internet_access" {
  description = "Create a route table for this subnet that enables outbound access."
  default     = false
}

variable "aws_internet_gateway_id" {
  description = "The ID of the internet gateway to use for when 'enable_internet_access' is enabled."
  default     = ""
}
